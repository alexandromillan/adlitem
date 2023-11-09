///
///  * [kSecondaryButton], the button this callback responds to.
///  * [LongPressMoveUpdateDetails], which is passed as an argument to this
///    callback. � GO�� IF��/// Called when the pointer stops contacting the screen after a long-press by
/// a secondary button.
///
/// This is equivalent to (and is called immediately after)
/// [onSecondaryLongPressEnd]. The only difference between the two is that
/// this callback does not contain details of the state of the pointer when
/// it stopped contacting the screen.
///
/// See also:
///
///  * [kSecondaryButton], the button this callback responds to. � Ic��� KЂ+/// Called when the pointer stops contacting the screen after a long-press by
/// a secondary button.
///
/// This is equivalent to (and is called immediately before)
/// [onSecondaryLongPressUp]. The only difference between the two is that
/// this callback contains details of the state of the pointer when it
/// stopped contacting the screen, whereas [onSecondaryLongPressUp] does not.
///
/// See also:
///
///  * [kSecondaryButton], the button this callback responds 