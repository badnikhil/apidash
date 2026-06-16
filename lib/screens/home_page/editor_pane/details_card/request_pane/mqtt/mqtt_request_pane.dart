import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'mqtt_request_topics.dart';

class EditMQTTRequestPane extends ConsumerStatefulWidget {
  const EditMQTTRequestPane({
    super.key,
    this.showViewCodeButton = true,
  });

  final bool showViewCodeButton;

  @override
  ConsumerState<EditMQTTRequestPane> createState() => _EditMQTTRequestPaneState();
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

    // Sync controllers if model changes from outside (e.g. selection)
    if (_messageController.text != mqttModel.message) {
      _messageController.text = mqttModel.message;
    }

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: "Message"),
              Tab(text: "Topics"),
              Tab(text: "Auth"),
              Tab(text: "Settings"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Message Tab
                Padding(
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
                              .where((e) => e.isNotEmpty && e.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                        },
                        onSelected: (String selection) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                            mqttRequestModel: mqttModel.copyWith(publishTopic: selection),
                          );
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          if (controller.text != mqttModel.publishTopic) {
                            controller.text = mqttModel.publishTopic;
                          }
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              labelText: "Send to topic:",
                              border: UnderlineInputBorder(),
                            ),
                            onChanged: (val) {
                              ref.read(collectionStateNotifierProvider.notifier).update(
                                mqttRequestModel: mqttModel.copyWith(publishTopic: val),
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
                            ref.read(collectionStateNotifierProvider.notifier).update(
                              mqttRequestModel: mqttModel.copyWith(message: val),
                            );
                          },
                        ),
                      ),
                      kVSpacer20,
                      ElevatedButton(
                        onPressed: (requestModel?.isStreaming ?? false) && selectedId != null && mqttModel.publishTopic.isNotEmpty
                            ? () {
                                ref.read(collectionStateNotifierProvider.notifier).sendMqttMessage(
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
                ),
                // Topic Subscriptions Tab
                const EditMQTTTopics(),
                // Auth Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: mqttModel.username,
                        decoration: const InputDecoration(labelText: "Username"),
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                            mqttRequestModel: mqttModel.copyWith(username: val),
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: mqttModel.password,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Password"),
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                            mqttRequestModel: mqttModel.copyWith(password: val),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Settings Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: mqttModel.clientId,
                        decoration: const InputDecoration(labelText: "Client ID"),
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                            mqttRequestModel: mqttModel.copyWith(clientId: val),
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: mqttModel.port.toString(),
                        decoration: const InputDecoration(labelText: "Port"),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final port = int.tryParse(val) ?? 1883;
                          ref.read(collectionStateNotifierProvider.notifier).update(
                            mqttRequestModel: mqttModel.copyWith(port: port),
                          );
                        },
                      ),
                      DropdownButtonFormField<int>(
                        value: mqttModel.qos,
                        decoration: const InputDecoration(labelText: "Default QoS"),
                        items: [0, 1, 2].map((q) {
                          return DropdownMenuItem(
                            value: q,
                            child: Text("QoS $q"),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(collectionStateNotifierProvider.notifier).update(
                              mqttRequestModel: mqttModel.copyWith(qos: val),
                            );
                          }
                        },
                      ),
                      DropdownButtonFormField<MQTTVersion>(
                        value: mqttModel.version,
                        decoration: const InputDecoration(labelText: "MQTT Version"),
                        items: MQTTVersion.values.map((v) {
                          return DropdownMenuItem(
                            value: v,
                            child: Text(v.name.toUpperCase().replaceAll("_", ".")),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(collectionStateNotifierProvider.notifier).update(
                              mqttRequestModel: mqttModel.copyWith(version: val),
                            );
                          }
                        },
                      ),
                      SwitchListTile(
                        title: const Text("Use TLS"),
                        value: mqttModel.useTLS,
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                            mqttRequestModel: mqttModel.copyWith(useTLS: val),
                          );
                        },
                      ),
                      SwitchListTile(
                        title: const Text("Use WebSocket"),
                        value: mqttModel.useWebSocket,
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                            mqttRequestModel: mqttModel.copyWith(useWebSocket: val),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
