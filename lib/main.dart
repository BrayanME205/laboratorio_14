import 'package:flutter/material.dart';

void main() {
  runApp(const FocusTrackApp());
}

/// Widget raiz inmutable que configura el tema visual de la aplicacion
class FocusTrackApp extends StatelessWidget {
  const FocusTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusTrack Móvil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          //seedColor: const Color(0xFF1A237E), // Azul Índigo Universitario
          seedColor: const Color(0xFF00796B), // Verde Esmeralda
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
      ),
      home: const PantallaPrincipalMetas(),
    );
  }
}

/// Pantalla con estado reactivo para registrar metas y productividad
class PantallaPrincipalMetas extends StatefulWidget {
  const PantallaPrincipalMetas({super.key});

  @override
  State<PantallaPrincipalMetas> createState() => _PantallaPrincipalMetasState();
}

class _PantallaPrincipalMetasState extends State<PantallaPrincipalMetas> {
  int _metasCompletadas = 0;
  final int _metaObjetivo = 5;
  String _nivelProductividad = 'Inicial';

  void _actualizarNivel() {
    if (_metasCompletadas == 0) {
      _nivelProductividad = 'Inicial';
    } else if (_metasCompletadas < _metaObjetivo) {
      _nivelProductividad = 'En Progreso';
    } else if (_metasCompletadas == _metaObjetivo) {
      _nivelProductividad = '¡Objetivo Alcanzado!';
    } else {
      _nivelProductividad =
          '¡Sobresaliente (+${_metasCompletadas - _metaObjetivo})!';
    }
  }

  void _incrementarMeta() {
    setState(() {
      _metasCompletadas++;
      _actualizarNivel();
    });
  }

  void _decrementarMeta() {
    setState(() {
      if (_metasCompletadas > 0) {
        _metasCompletadas--;
        _actualizarNivel();
      }
    });
  }

  void _reiniciarContadores() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Reinicio'),
          content: const Text(
            '¿Desea restablecer todas las metas completadas a cero?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _metasCompletadas = 0;
                  _actualizarNivel();
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Metas restablecidas exitosamente.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Reiniciar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;
    final porcentaje = (_metasCompletadas / _metaObjetivo).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusTrack Móvil'),
        backgroundColor: colores.primaryContainer,
        foregroundColor: colores.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reiniciar sesión de metas',
            onPressed: _reiniciarContadores,
          ),
        ],
      ),
      // SafeArea garantiza visualizacion correcta fuera del notch
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarjeta de Resumen Ejecutivo
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.track_changes,
                        size: 52.0,
                        color: colores.primary,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Progreso del Día',
                        style: tema.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '$_metasCompletadas / $_metaObjetivo',
                        style: tema.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colores.primary,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: LinearProgressIndicator(
                          value: porcentaje,
                          minHeight: 10.0,
                          backgroundColor: colores.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _metasCompletadas >= _metaObjetivo
                                ? Colors.teal
                                : colores.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Chip(
                        avatar: Icon(
                          _metasCompletadas >= _metaObjetivo
                              ? Icons.emoji_events
                              : Icons.bolt,
                          color: colores.onSecondaryContainer,
                        ),
                        label: Text(
                          _nivelProductividad,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colores.onSecondaryContainer,
                          ),
                        ),
                        backgroundColor: colores.secondaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Panel de Informacion Tecnica
              Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: colores.outlineVariant),
                ),
                child: const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Sesión Móvil Activa'),
                  subtitle: Text(
                    'Renderizado nativo impulsado por el motor Impeller '
                    'y gestionado con Hot Reload.',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Botones Flotantes de Accion
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn_decrementar',
            onPressed: _decrementarMeta,
            tooltip: 'Restar meta completada',
            backgroundColor: colores.surfaceContainerHighest,
            foregroundColor: colores.onSurfaceVariant,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 14.0),
          FloatingActionButton.extended(
            heroTag: 'btn_incrementar',
            onPressed: _incrementarMeta,
            tooltip: 'Completar meta',
            backgroundColor: colores.primary,
            foregroundColor: colores.onPrimary,
            icon: const Icon(Icons.check),
            label: const Text('Completar Meta'),
          ),
        ],
      ),
    );
  }
}
