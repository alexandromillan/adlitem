 difference between the two is that
/// this callback does not contain details of the state of the pointer when
/// it stopped contacting the screen.
///
/// See also:
///
///  * [kTertiaryButton], the button this callback responds to. � Z>�� \��'/// Called when the pointer stops contacting the screen after a long-press by
/// a tertiary button.
///
/// This is equivalent to (and is called immediately before)
/// [onTertiaryLongPressUp]. The only difference between the two is that
/// this callback contains details of the state of the pointer when it
/// stopped contacting the screen, whereas [onTertiaryLongPressUp] does not.
///
/// See also:
///
///  * [kTertiaryButton], the button this callback responds to.
///  * [LongPressEndDetails], which is passed as an argument to this callback. � \�!� \�  � ��9� �   � ��� ���4���@  �]�b   � \�@� \�  � ]� ]!  � \�� \�� b2�� bD   � b2� b3� c>�� cP  � ce� cs  � c>� c?� h_��� hd  � hx� h�   � l0��� l5    � o0��� o5    � u��<� u�  � u�� u�   � y���� y�  � z� z   � ���� �    � ����� ��  � ��� ��  � ��� ��� ���� �&  � �4� �9  � �� �       ��o�
�/// Callback signature for [LongPressGestureRecognizer.onLongPressDown].
///
/// Called when a pointer that might cause a long-press has contacted the
/// screen. The position at which the pointer contacted the screen is available
/// in the `details`.
///
/// See also:
///
///  * [GestureDetector.onLongPressDown], which matches this signature.
///  * [GestureLongPressStartCallback], the signature that gets called when the
///    pointer has been in contact with the screen long enough to be considered
///    a long-press.  �7�M   �Y�q���//// Callback signature for [LongPressGestureRecognizer.onLongPressCancel].
///
/// Called when the pointer that previously triggered a
/// [GestureLongPressDownCallback] will not end up causing a long-press.
///
/// See also:
///
///  * [GestureDetector.onLongPressCancel], which matches this signature.    �΁ԇw��/// Callback signature for [LongPressGestureRecognizer.onLongPress].
///
/// Called when a pointer has remained in contact with the screen at the
/// same location for a long period of time.
///
/// See also:
///
///  * [GestureDetector.onLongPress], which matches this signature.
///  * [GestureLongPressStartCallback], which is the same signature but with
///    details of where the long press occurred.    ���G���	/// Callback signature for [LongPressGestureRecognizer.onLongPressUp].
///
/// Called when a pointer stops contacting the screen after a long press
/// gesture was detected.
///
/// See also:
///
///  * [GestureDetector.onLongPressUp], which matches this signature.    ������/// Callback signature for [LongPressGestureRecognizer.onLongPressStart].
///
/// Called when a pointer has remained in contact with the screen at the
/// same location for a long period of time. Also reports the long press down
/// position.
///
/// See also:
///
///  * [GestureDetector.onLongPressStart], which matches this signature.
///  * [GestureLongPressCallback], which is the same signature without the
///    details.  ����   ������w/// Callback signature for [LongPressGestureRecognize