import 'package:flutter/material.dart';

class BotaoCadastroExpandido extends StatefulWidget {
  const BotaoCadastroExpandido({super.key});

  @override
  State<BotaoCadastroExpandido> createState() => _BotaoCadastroExpandidoState();
}

class _BotaoCadastroExpandidoState extends State<BotaoCadastroExpandido> {
  final OverlayPortalController _tooltipController = OverlayPortalController();

  final LayerLink _layerLink = LayerLink();

  void abrirOpcoesCadastro() {
    _tooltipController.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _tooltipController,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('Cadastrar Imóvel'),
                        onTap: () {
                          _tooltipController.hide();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Cadastrar Cliente'),
                        onTap: () {
                          _tooltipController.hide();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: ElevatedButton.icon(
          onPressed: abrirOpcoesCadastro,
          icon: const Icon(Icons.add),
          label: const Text('Cadastrar'),
        ),
      ),
    );
  }
}
