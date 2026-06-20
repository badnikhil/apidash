import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'mqtt_request_topics.dart';
import 'mqtt_user_properties.dart';

class EditMQTTRequestPane extends ConsumerStatefulWidget {
  const EditMQTTRequestPane({super.key, this.showViewCodeButton = true});

  final bool showViewCodeButton;

  @override
  ConsumerState<EditMQTTRequestPane> createState() =>
      _EditMQTTRequestPaneState();
}

class _EditMQTTRequestPaneState extends ConsumerState<EditMQTTRequestPane> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref.watch(selectedRequestModelProvider);
    final mqttModel = requestModel?.mqttRequestModel;

    if (mqttModel == null) return kSizedBoxEmpty;

    // Progressive disclosure: the v5-only surfaces (User Properties tab,
    // Request/Response + Message Expiry on publish, Session Expiry) appear ONLY
    // when MQTT 5.0 is selected, so v3 users never see the extra clutter.
    final isV5 = mqttModel.version == MQTTVersion.v5;

    // Sync controllers if model changes from outside (e.g. selection)
    if (_messageController.text != mqttModel.message) {
      _messageController.text = mqttModel.message;
    }

    final tabs = <Tab>[
      const Tab(text: "Message"),
      const Tab(text: "Topics"),
      if (isV5) const Tab(text: "Properties"),
      const Tab(text: "Auth"),
      const Tab(text: "Settings"),
    ];

    final views = <Widget>[
      _buildMessageTab(context, selectedId, requestModel, mqttModel, isV5),
      const EditMQTTTopics(),
      if (isV5) const EditMQTTUserProperties(),
      _buildAuthTab(mqttModel),
      _buildSettingsTab(mqttModel, isV5),
    ];

    return DefaultTabController(
      length: tabs.length,
      // ValueKey forces the controller to rebuild when v5 toggles the tab
      // count, avoiding a length/controller mismatch.
      key: ValueKey('mqtt-tabs-${isV5 ? 5 : 4}'),
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant,
            isScrollable: false,
            tabs: tabs,
          ),
          Expanded(child: TabBarView(children: views)),
        ],
      ),
    );
  }

  Widget _buildMessageTab(
    BuildContext context,
    String? selectedId,
    dynamic requestModel,
    MQTTRequestModel mqttModel,
    bool isV5,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Autocomplete<String>(
            initialValue: TextEditingValue(text: mqttModel.publishTopic),
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return mqttModel.subscribedTopics
                    .map((e) => e.name)
                    .where((e) => e.isNotEmpty);
              }
              return mqttModel.subscribedTopics
                  .map((e) => e.name)
                  .where(
                    (e) =>
                        e.isNotEmpty &&
                        e.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                  );
            },
            onSelected: (String selection) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(
                    mqttRequestModel: mqttModel.copyWith(
                      publishTopic: selection,
                    ),
                  );
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  if (controller.text != mqttModel.publishTopic) {
                    controller.text = mqttModel.publishTopic;
                  }
                  return EnvironmentTriggerField(
                    keyId: "mqtt-publish-topic-$selectedId",
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: "Send to topic:",
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (val) {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .update(
                            mqttRequestModel: mqttModel.copyWith(
                              publishTopic: val,
                            ),
                          );
                    },
                  );
                },
          ),
          kVSpacer20,
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: kCodeStyle,
              decoration: InputDecoration(
                hintText: "Enter message...",
                hintStyle: kCodeStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (val) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .update(mqttRequestModel: mqttModel.copyWith(message: val));
              },
            ),
          ),
          // ── v5-only: Request/Response + Message Expiry (collapsed) ──────
          if (isV5) _buildV5PublishOptions(mqttModel),
          kVSpacer20,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Retain"),
              Switch(
                value: mqttModel.retainMessage,
                onChanged: (val) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(
                        mqttRequestModel: mqttModel.copyWith(
                          retainMessage: val,
                        ),
                      );
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed:
                    (requestModel?.isStreaming ?? false) &&
                        selectedId != null &&
                        mqttModel.publishTopic.isNotEmpty
                    ? () {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .sendMqttMessage(
                              selectedId,
                              _messageController.text,
                              mqttModel.publishTopic,
                            );
                      }
                    : null,
                child: const Text("Publish"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// v5-only publish options, tucked into a collapsed ExpansionTile so they
  /// stay out of the way until needed (one tap to reveal).
  Widget _buildV5PublishOptions(MQTTRequestModel mqttModel) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(
          "Request / Response & Expiry (v5)",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        children: [
          EnvAuthField(
            initialValue: mqttModel.responseTopic,
            hintText: "Topic the responder should reply to",
            title: "Response Topic",
            onChanged: (val) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(
                    mqttRequestModel: mqttModel.copyWith(responseTopic: val),
                  );
            },
          ),
          kVSpacer8,
          EnvAuthField(
            initialValue: mqttModel.correlationData,
            hintText: "Opaque token to match request ↔ response",
            title: "Correlation Data",
            onChanged: (val) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(
                    mqttRequestModel: mqttModel.copyWith(correlationData: val),
                  );
            },
          ),
          kVSpacer8,
          EnvAuthField(
            initialValue: mqttModel.messageExpiryInterval == 0
                ? ""
                : mqttModel.messageExpiryInterval.toString(),
            hintText: "0 / empty = no expiry",
            title: "Message Expiry Interval (seconds)",
            onChanged: (val) {
              final parsed = int.tryParse(val) ?? 0;
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(
                    mqttRequestModel: mqttModel.copyWith(
                      messageExpiryInterval: parsed,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAuthTab(MQTTRequestModel mqttModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          EnvAuthField(
            initialValue: mqttModel.username,
            hintText: "Username",
            title: "Username",
            onChanged: (val) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(mqttRequestModel: mqttModel.copyWith(username: val));
            },
          ),
          EnvAuthField(
            initialValue: mqttModel.password,
            isObscureText: true,
            hintText: "Password",
            title: "Password",
            onChanged: (val) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(mqttRequestModel: mqttModel.copyWith(password: val));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(MQTTRequestModel mqttModel, bool isV5) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Row 1: Client ID & Port
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: EnvAuthField(
                  initialValue: mqttModel.clientId,
                  hintText: "Client ID",
                  title: "Client ID",
                  onChanged: (val) {
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(
                          mqttRequestModel: mqttModel.copyWith(clientId: val),
                        );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: mqttModel.port.toString(),
                  decoration: const InputDecoration(labelText: "Port"),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final port = int.tryParse(val) ?? 1883;
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(
                          mqttRequestModel: mqttModel.copyWith(port: port),
                        );
                  },
                ),
              ),
            ],
          ),
          kVSpacer16,
          // Row 2: Keep Alive & Default QoS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EnvAuthField(
                  initialValue: mqttModel.keepAlivePeriod.toString(),
                  hintText: "60",
                  title: "Keep Alive (s)",
                  onChanged: (val) {
                    final parsed = int.tryParse(val) ?? 60;
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(
                          mqttRequestModel: mqttModel.copyWith(
                            keepAlivePeriod: parsed,
                          ),
                        );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: mqttModel.qos,
                  decoration: const InputDecoration(labelText: "Default QoS"),
                  items: [0, 1, 2]
                      .map(
                        (q) =>
                            DropdownMenuItem(value: q, child: Text("QoS $q")),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .update(
                            mqttRequestModel: mqttModel.copyWith(qos: val),
                          );
                    }
                  },
                ),
              ),
            ],
          ),
          kVSpacer16,
          // Row 3: Session Expiry (only v5)
          if (isV5) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Clean Start"),
                    subtitle: const Text("Session ends on disconnect"),
                    value: mqttModel.sessionExpiryInterval == 0,
                    onChanged: (val) {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .update(
                            mqttRequestModel: mqttModel.copyWith(
                              sessionExpiryInterval: val ? 0 : 3600,
                            ),
                          );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                if (mqttModel.sessionExpiryInterval > 0)
                  Expanded(
                    child: EnvAuthField(
                      initialValue: mqttModel.sessionExpiryInterval.toString(),
                      hintText: "3600",
                      title: "Session Expiry (s)",
                      onChanged: (val) {
                        final parsed = int.tryParse(val) ?? 0;
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .update(
                              mqttRequestModel: mqttModel.copyWith(
                                sessionExpiryInterval: parsed,
                              ),
                            );
                      },
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
            kVSpacer16,
          ],

          // Security / Transport Options
          ExpansionTile(
            title: const Text("Transport & Security"),
            initiallyExpanded: mqttModel.useTLS || mqttModel.useWebSocket,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Use TLS"),
                subtitle: const Text("Encrypt the connection (TLS/SSL)"),
                value: mqttModel.useTLS,
                onChanged: (val) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(
                        mqttRequestModel: mqttModel.copyWith(useTLS: val),
                      );
                },
              ),
              if (mqttModel.useTLS)
                SwitchListTile(
                  contentPadding: const EdgeInsets.only(left: 16),
                  title: const Text("Allow Invalid Certificates"),
                  subtitle: const Text("Accept self-signed / untrusted certs"),
                  value: mqttModel.allowInvalidCertificates,
                  onChanged: (val) {
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(
                          mqttRequestModel: mqttModel.copyWith(
                            allowInvalidCertificates: val,
                          ),
                        );
                  },
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Use WebSocket"),
                subtitle: const Text("Tunnel MQTT over a WebSocket transport"),
                value: mqttModel.useWebSocket,
                onChanged: (val) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(
                        mqttRequestModel: mqttModel.copyWith(useWebSocket: val),
                      );
                },
              ),
              kVSpacer8,
            ],
          ),
          kVSpacer16,

          // LWT Options
          ExpansionTile(
            title: const Text("Last Will & Testament (LWT)"),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: EnvAuthField(
                      initialValue: mqttModel.willTopic,
                      hintText: "Will Topic",
                      title: "Will Topic",
                      onChanged: (val) {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .update(
                              mqttRequestModel: mqttModel.copyWith(
                                willTopic: val,
                              ),
                            );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: EnvAuthField(
                      initialValue: mqttModel.willMessage,
                      hintText: "Will Message",
                      title: "Will Message",
                      onChanged: (val) {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .update(
                              mqttRequestModel: mqttModel.copyWith(
                                willMessage: val,
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
              kVSpacer8,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: mqttModel.willQos,
                      decoration: const InputDecoration(labelText: "Will QoS"),
                      items: [0, 1, 2]
                          .map(
                            (q) => DropdownMenuItem(
                              value: q,
                              child: Text("QoS $q"),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          ref
                              .read(collectionStateNotifierProvider.notifier)
                              .update(
                                mqttRequestModel: mqttModel.copyWith(
                                  willQos: val,
                                ),
                              );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Retain Will"),
                      value: mqttModel.willRetain,
                      onChanged: (val) {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .update(
                              mqttRequestModel: mqttModel.copyWith(
                                willRetain: val,
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
              kVSpacer8,
            ],
          ),
          kVSpacer16,
        ],
      ),
    );
  }
}
