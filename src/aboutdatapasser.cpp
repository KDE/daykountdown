/*
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

#include "aboutdatapasser.h"

AboutDataPasser::AboutDataPasser(QObject *parent) : QObject(parent)
{

}

void AboutDataPasser::setAboutData(const KAboutData &aboutData) {
	m_aboutData = aboutData;
}

KAboutData AboutDataPasser::aboutData() const {
	return m_aboutData;
}
