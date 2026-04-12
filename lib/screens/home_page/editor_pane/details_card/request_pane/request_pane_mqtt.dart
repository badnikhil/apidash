import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/protocols/mqtt_model.dart';
import 'package:apidash/services/connection_manager.dart';

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
  final TextEditingController _topicController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref.watch(selectedRequestModelProvider);
    final protocolModel = requestModel?.protocolModel;
    final mqttModel = protocolModel is MQTTRequestModel ? protocolModel : null;

    if (mqttModel == null) return kSizedBoxEmpty;

    // Sync controllers if model changes from outside (e.g. selection)
    if (_messageController.text != mqttModel.message) {
        _messageController.text = mqttModel.message;
    }
    if (_topicController.text != mqttModel.publishTopic) {
        _topicController.text = mqttModel.publishTopic;
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
              Tab(text: "Auth"),
              Tab(text: "Settings"),
              Tab(text: "Topics"),
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
                               protocolModel: mqttModel.copyWith(message: val),
                             );
                          },
                        ),
                      ),
                      kVSpacer20,
                       ElevatedButton(
                            onPressed: (requestModel?.isStreaming ?? false) ? () {
                               if (selectedId != null && _topicController.text.isNotEmpty) {
                                  ref.read(collectionStateNotifierProvider.notifier).sendMqttMessage(
                                    selectedId,
                                    _topicController.text,
                                    _messageController.text,
                                  );
                               }
                            } : null,
                            child: const Text("Publish"),
                          ),
                      kVSpacer20,
                      TextField(
                        controller: _topicController,
                        decoration: const InputDecoration(
                            labelText: "Send to topic:",
                            border: UnderlineInputBorder(),
                        ),
                        onChanged: (val) {
                             ref.read(collectionStateNotifierProvider.notifier).update(
                               protocolModel: mqttModel.copyWith(publishTopic: val),
                             );
                        },
                      ),
                    ],
                  ),
                ),
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
                               protocolModel: mqttModel.copyWith(username: val),
                             );
                        },
                      ),
                      TextFormField(
                        initialValue: mqttModel.password,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Password"),
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                               protocolModel: mqttModel.copyWith(password: val),
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
                               protocolModel: mqttModel.copyWith(clientId: val),
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
                               protocolModel: mqttModel.copyWith(port: port),
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
                                  protocolModel: mqttModel.copyWith(qos: val),
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
                                  protocolModel: mqttModel.copyWith(version: val),
                                );
                          }
                        },
                      ),
                      SwitchListTile(
                        title: const Text("Use TLS"),
                        value: mqttModel.useTLS,
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                               protocolModel: mqttModel.copyWith(useTLS: val),
                             );
                        },
                      ),
                      SwitchListTile(
                        title: const Text("Use WebSocket"),
                        value: mqttModel.useWebSocket,
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                               protocolModel: mqttModel.copyWith(useWebSocket: val),
                             );
                        },
                      ),
                    ],
                  ),
                ),
                // Topic Subscriptions Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                       Expanded(
                        child: ListView.builder(
                          itemCount: mqttModel.subscribedTopics.length,
                          itemBuilder: (context, index) {
                            final topic = mqttModel.subscribedTopics[index];
                            return ListTile(
                              title: Text(topic),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  final newList = List<String>.from(mqttModel.subscribedTopics)..removeAt(index);
                                  ref.read(collectionStateNotifierProvider.notifier).update(
                                        protocolModel: mqttModel.copyWith(subscribedTopics: newList),
                                      );
                                  if ((requestModel?.isStreaming ?? false) && selectedId != null) {
                                     ConnectionManager.instance.unsubscribeMqtt(selectedId, topic);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                       TextField(
                          decoration: const InputDecoration(hintText: "Add topic to subscribe..."),
                            onSubmitted: (value) {
                             if (selectedId != null && value.isNotEmpty) {
                               final newList = List<String>.from(mqttModel.subscribedTopics)..add(value);
                               ref.read(collectionStateNotifierProvider.notifier).update(
                                     protocolModel: mqttModel.copyWith(subscribedTopics: newList),
                                   );
                               if (requestModel?.isStreaming ?? false) {
                                  ConnectionManager.instance.subscribeMqtt(selectedId, value, mqttModel.qos);
                               }
                             }
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
