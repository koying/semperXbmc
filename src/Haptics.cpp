#include "Haptics.h"

#ifdef Q_OS_SYMBIAN
#include <QFeedbackEffect>
QTM_USE_NAMESPACE
#endif

Haptics::Haptics(QObject *parent) :
    QObject(parent)
{
}

void Haptics::basicButtonClick() {
#ifdef Q_OS_SYMBIAN
    QFeedbackEffect::playThemeEffect(QFeedbackEffect::ThemeBasicButton);
#endif
}

void Haptics::sensitiveButtonClick()
{
#ifdef Q_OS_SYMBIAN
    QFeedbackEffect::playThemeEffect(QFeedbackEffect::ThemeSensitiveButton);
#endif
}
