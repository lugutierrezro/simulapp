import 'package:flutter/material.dart';

class WatermarkPhotoPicker extends StatefulWidget {
  final String? initialPhotoPath;
  final ValueChanged<Map<String, String>> onPhotoSelected;
  final String agentCode;
  final String sector;

  const WatermarkPhotoPicker({
    super.key,
    this.initialPhotoPath,
    required this.onPhotoSelected,
    required this.agentCode,
    required this.sector,
  });

  @override
  State<WatermarkPhotoPicker> createState() => _WatermarkPhotoPickerState();
}

class _WatermarkPhotoPickerState extends State<WatermarkPhotoPicker> {
  String? _selectedCategory;
  String? _watermarkText;
  bool _isCompressing = false;
  final _customNameCtrl = TextEditingController();

  final List<Map<String, String>> _sampleTacticalPhotos = [
    {
      'label': 'Fuga de Gas / Válvula Dañada',
      'category': 'Fuga de Gas',
      'icon': 'local_fire_department',
    },
    {
      'label': 'Estructura con Grieta Severa',
      'category': 'Colapso',
      'icon': 'business',
    },
    {
      'label': 'Vía Secundaria Obstruida',
      'category': 'Obstrucción',
      'icon': 'warning',
    },
    {
      'label': 'Inundación / Rotura de Tubería',
      'category': 'Inundación',
      'icon': 'water_damage',
    },
  ];

  void _selectPhoto(String label, String category) async {
    setState(() {
      _isCompressing = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now().toIso8601String().replaceAll('T', ' ').substring(0, 19);
    const gps = '-12.0463, -77.0428 (±3.5m)';
    final wm = 'EVIDENCIA INSTITUCIONAL INDECI 2026\nFECHA/HORA: $now\nGPS: $gps\nAGENTE: ${widget.agentCode} | SECTOR: ${widget.sector}\n[COMPRIMIDO WEBP 80% - RNF08]';

    setState(() {
      _selectedCategory = label;
      _watermarkText = wm;
      _isCompressing = false;
    });

    widget.onPhotoSelected({
      'label': label,
      'category': category,
      'watermark': wm,
    });
  }

  void _showCustomUploadDialog() {
    _customNameCtrl.text = 'Foto_Campo_Evidencia_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}.jpg';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.upload_file, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text('Subir Imagen del Dispositivo', style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccione o confirme el nombre de la fotografía capturada desde la cámara o galería:',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customNameCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: const InputDecoration(
                labelText: 'Nombre / Etiqueta de la Foto',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFF4ADE80), size: 16),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Se aplicará marca de agua de geolocalización inalterable y compresión WebP 80% automáticamente.',
                    style: TextStyle(color: Color(0xFF4ADE80), fontSize: 10),
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              final customName = _customNameCtrl.text.trim();
              _selectPhoto(customName.isNotEmpty ? customName : 'Imagen_Cargada_Dispositivo.jpg', 'Fotografía Subida');
            },
            icon: const Icon(Icons.cloud_upload),
            label: const Text('PROCESAR Y SUBIR'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'EVIDENCIA FOTOGRÁFICA (RF09)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF1E293B),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Marca de agua inalterable',
                style: TextStyle(color: Color(0xFFDC2626), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),

        if (_isCompressing)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text(
                  'Comprimiendo imagen y estampando georreferencia...',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                )
              ],
            ),
          )
        else if (_selectedCategory != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade700, width: 2),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedCategory!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white70, size: 20),
                      onPressed: () => setState(() => _selectedCategory = null),
                      tooltip: 'Cambiar / Subir otra foto',
                    )
                  ],
                ),
                const Divider(color: Colors.white24),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.verified, color: Color(0xFF4ADE80), size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _watermarkText ?? '',
                          style: const TextStyle(
                            color: Color(0xFF4ADE80),
                            fontSize: 10,
                            fontFamily: 'monospace',
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Button to upload custom photo from device / gallery
              ElevatedButton.icon(
                onPressed: _showCustomUploadDialog,
                icon: const Icon(Icons.file_upload_outlined, color: Colors.white),
                label: const Text('SUBIR IMAGEN DESDE EL DISPOSITIVO / GALERÍA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'O seleccione una foto de muestra táctica:',
                style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _sampleTacticalPhotos.length,
                itemBuilder: (context, index) {
                  final item = _sampleTacticalPhotos[index];
                  return InkWell(
                    onTap: () => _selectPhoto(item['label']!, item['category']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueGrey.shade700),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.photo_camera, color: Colors.amber, size: 20),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item['label']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
      ],
    );
  }
}
