import 'package:flutter/material.dart';

/// One line of an answer, as the renderer lays it out.
sealed class AnswerBlock {
  const AnswerBlock(this.text);

  /// The line's text, still with its inline marks (`**bold**`, `*italic*`).
  final String text;
}

final class HeadingBlock extends AnswerBlock {
  const HeadingBlock(super.text);
}

final class BulletBlock extends AnswerBlock {
  const BulletBlock(super.text);
}

final class NumberedBlock extends AnswerBlock {
  const NumberedBlock(this.number, String text) : super(text);

  final String number;
}

final class ParagraphBlock extends AnswerBlock {
  const ParagraphBlock(super.text);
}

/// A blank line between paragraphs.
final class GapBlock extends AnswerBlock {
  const GapBlock() : super('');
}

final _heading = RegExp(r'^#{1,6}\s+(.*)$');
final _bullet = RegExp(r'^[-*•]\s+(.*)$');
final _numbered = RegExp(r'^(\d{1,3})[.)]\s+(.*)$');
final _tableRule = RegExp(r'^\|?\s*:?-{2,}');
final _inline = RegExp(r'\*\*(.+?)\*\*|__(.+?)__|\*(\S(?:.*?\S)?)\*|`([^`]+)`');

/// The subset of Markdown the assistant is asked to write: headings, bullet
/// and numbered lists, and paragraphs. Anything else (a table it wrote
/// anyway) comes out as plain lines rather than raw symbols.
List<AnswerBlock> parseAnswer(String markdown) {
  final blocks = <AnswerBlock>[];
  for (final raw in markdown.replaceAll('\r\n', '\n').split('\n')) {
    final line = raw.trim();
    if (line.isEmpty) {
      if (blocks.isNotEmpty && blocks.last is! GapBlock) {
        blocks.add(const GapBlock());
      }
      continue;
    }
    if (line.startsWith('|')) {
      if (_tableRule.hasMatch(line)) continue;
      final cells = line
          .split('|')
          .map((cell) => cell.trim())
          .where((cell) => cell.isNotEmpty);
      blocks.add(ParagraphBlock(cells.join(' · ')));
    } else if (_heading.firstMatch(line) case final match?) {
      blocks.add(HeadingBlock(match[1]!));
    } else if (_bullet.firstMatch(line) case final match?) {
      blocks.add(BulletBlock(match[1]!));
    } else if (_numbered.firstMatch(line) case final match?) {
      blocks.add(NumberedBlock(match[1]!, match[2]!));
    } else if (RegExp(r'^-{3,}$').hasMatch(line)) {
      continue;
    } else {
      blocks.add(ParagraphBlock(line));
    }
  }
  if (blocks.isNotEmpty && blocks.last is GapBlock) blocks.removeLast();
  return blocks;
}

/// [markdown] as plain text, for copying and sharing: the marks are gone,
/// the lists keep a simple bullet.
String plainAnswer(String markdown) => [
  for (final block in parseAnswer(markdown))
    switch (block) {
      GapBlock() => '',
      BulletBlock(:final text) => '• ${_stripInline(text)}',
      NumberedBlock(:final number, :final text) =>
        '$number. ${_stripInline(text)}',
      _ => _stripInline(block.text),
    },
].join('\n');

String _stripInline(String text) =>
    text.replaceAllMapped(_inline, (m) => m[1] ?? m[2] ?? m[3] ?? m[4] ?? '');

List<InlineSpan> _spans(String text) {
  final spans = <InlineSpan>[];
  var at = 0;
  for (final m in _inline.allMatches(text)) {
    if (m.start > at) spans.add(TextSpan(text: text.substring(at, m.start)));
    final (inner, style) = switch (m) {
      _ when m[1] != null => (
        m[1]!,
        const TextStyle(fontWeight: FontWeight.bold),
      ),
      _ when m[2] != null => (
        m[2]!,
        const TextStyle(fontWeight: FontWeight.bold),
      ),
      _ when m[3] != null => (
        m[3]!,
        const TextStyle(fontStyle: FontStyle.italic),
      ),
      _ => (m[4]!, const TextStyle(fontFamily: 'monospace')),
    };
    spans.add(TextSpan(text: inner, style: style));
    at = m.end;
  }
  if (at < text.length) spans.add(TextSpan(text: text.substring(at)));
  return spans;
}

/// An assistant answer drawn from its Markdown.
class MarkdownAnswer extends StatelessWidget {
  const MarkdownAnswer(this.markdown, {super.key, this.style});

  final String markdown;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? DefaultTextStyle.of(context).style;
    Widget line(String text, {TextStyle? extra}) =>
        Text.rich(TextSpan(style: base.merge(extra), children: _spans(text)));

    Widget item(String marker, String text) => Padding(
      padding: const EdgeInsetsDirectional.only(top: 2, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 22, child: Text(marker, style: base)),
          Expanded(child: line(text)),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final block in parseAnswer(markdown))
          switch (block) {
            GapBlock() => const SizedBox(height: 8),
            HeadingBlock(:final text) => Padding(
              padding: const EdgeInsetsDirectional.only(top: 4, bottom: 2),
              child: line(
                text,
                extra: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            BulletBlock(:final text) => item('•', text),
            NumberedBlock(:final number, :final text) => item('$number.', text),
            ParagraphBlock(:final text) => line(text),
          },
      ],
    );
  }
}
