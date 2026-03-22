import 'package:flutter/widgets.dart';

class UndoIntent extends Intent { const UndoIntent(); }
class RedoIntent extends Intent { const RedoIntent(); }
class CopyIntent extends Intent { const CopyIntent(); }
class CutIntent extends Intent { const CutIntent(); }
class PasteIntent extends Intent { const PasteIntent(); }
class SelectAllIntent extends Intent { const SelectAllIntent(); }
class DeleteNodeIntent extends Intent { const DeleteNodeIntent(); }
class SaveIntent extends Intent { const SaveIntent(); }
