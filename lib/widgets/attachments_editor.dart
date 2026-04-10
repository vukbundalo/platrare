import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';

import '../l10n/app_localizations.dart';

enum AttachmentPickSource { camera, gallery, files }

/// Bottom sheet: camera / gallery / files (same flow as Track’s new transaction).
class AttachmentSourceSheet extends StatelessWidget {
  const AttachmentSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _AttachmentSourceTile(
              icon: Icons.camera_alt_rounded,
              label: AppLocalizations.of(context).attachTakePhoto,
              subtitle: AppLocalizations.of(context).attachTakePhotoSub,
              onTap: () =>
                  Navigator.pop(context, AttachmentPickSource.camera),
            ),
            const SizedBox(height: 8),
            _AttachmentSourceTile(
              icon: Icons.photo_library_rounded,
              label: AppLocalizations.of(context).attachChooseGallery,
              subtitle: AppLocalizations.of(context).attachChooseGallerySub,
              onTap: () =>
                  Navigator.pop(context, AttachmentPickSource.gallery),
            ),
            const SizedBox(height: 8),
            _AttachmentSourceTile(
              icon: Icons.folder_open_rounded,
              label: AppLocalizations.of(context).attachBrowseFiles,
              subtitle: AppLocalizations.of(context).attachBrowseFilesSub,
              onTap: () => Navigator.pop(context, AttachmentPickSource.files),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentSourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _AttachmentSourceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: cs.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// Returns new absolute paths to append (dedupe in the caller).
Future<List<String>> pickNewAttachmentPaths(BuildContext context) async {
  final choice = await showModalBottomSheet<AttachmentPickSource>(
    context: context,
    builder: (ctx) => const AttachmentSourceSheet(),
  );
  if (choice == null) return [];

  switch (choice) {
    case AttachmentPickSource.camera:
      final img = await ImagePicker().pickImage(source: ImageSource.camera);
      if (img == null) return [];
      return [img.path];
    case AttachmentPickSource.gallery:
      final imgs = await ImagePicker().pickMultiImage();
      return imgs.map((e) => e.path).toList();
    case AttachmentPickSource.files:
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result == null) return [];
      return result.files
          .where((f) => f.path != null)
          .map((f) => f.path!)
          .toList();
  }
}

/// Thumbnails + add/remove, matching Track’s new-transaction attachments row.
class AttachmentsEditorSection extends StatelessWidget {
  final List<String> attachments;
  final VoidCallback onAdd;
  final void Function(String path) onRemove;

  const AttachmentsEditorSection({
    super.key,
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
  });

  static const _imageExts = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif'};

  bool _isImage(String path) {
    final ext = path.split('.').last.toLowerCase();
    return _imageExts.contains(ext);
  }

  String _filename(String path) => path.split('/').last;

  IconData _fileIcon(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (ext == 'pdf') return Icons.picture_as_pdf_rounded;
    if (ext == 'doc' || ext == 'docx') return Icons.description_rounded;
    if (ext == 'xls' || ext == 'xlsx') return Icons.table_chart_rounded;
    return Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...attachments.map((path) {
          final isImg = _isImage(path);
          return GestureDetector(
            onTap: () => OpenFilex.open(path),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: isImg ? 80 : null,
                  height: isImg ? 80 : null,
                  padding: isImg
                      ? null
                      : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.6)),
                  ),
                  child: isImg
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(path),
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            errorBuilder: (ctx, err, trace) => Icon(
                              Icons.broken_image_rounded,
                              size: 32,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_fileIcon(path), size: 18, color: cs.primary),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: Text(
                                _filename(path),
                                style: TextStyle(
                                    fontSize: 12, color: cs.onSurface),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                ),
                Positioned(
                  top: -16,
                  right: -16,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onRemove(path),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: cs.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 12, color: cs.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.attach_file_rounded, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context).attachButton,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
