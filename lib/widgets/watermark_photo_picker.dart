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

  final List<Map<String, String>> _sampleTacticalPhotos = [
    {
      'label': 'Fuga de Gas / Válvula Dañada',
      'category': 'Fuga de Gas',
      'icon': 'local_fire_department',
      'bgGradient': 'orange',
    },
    {
      'label': 'Estructura con Grieta Severa',
      'category': 'Colapso',
      'icon': 'business',
      'bgGradient': 'red',
    },
    {
      'label': 'Vía Secundaria Obstruida',
      'category': 'Obstrucción',
      'icon': 'warning',
      'bgGradient': 'amber',
    },
    {
      'label': 'Inundación / Rotura de Tubería',
      'category': 'Inundación',
      'icon': 'water_damage',
      'bgGradient': 'blue',
    },
  ];

  void _selectPhoto(Map<String, String> item) async {
    setState(() {
      _isCompressing = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now().toIso8601String().replaceAll('T', ' ').substring(0, 19);
    const gps = '-12.0463, -77.0428 (±3.5m)';
    final wm = 'EVIDENCIA INSTITUCIONAL INDECI 2026\nFECHA/HORA: $now\nGPS: $gps\nAGENTE: ${widget.agentCode} | SECTOR: ${widget.sector}\n[COMPRIMIDO WEBP 80% - RNF08]';

    setState(() {
      _selectedCategory = item['label'];
      _watermarkText = wm;
      _isCompressing = false;
    });

    widget.onPhotoSelected({
      'label': item['label']!,
      'category': item['category']!,
      'watermark': wm,
    });
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
                      tooltip: 'Cambiar Foto',
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
              const Text(
                'Seleccione evidencia táctica para capturar y estampar:',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
              const SizedBox(height: 8),
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
                    onTap: () => _selectPhoto(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueGrey.shade700),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.photo_camera, color: Colors.amber, size: 22),
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
