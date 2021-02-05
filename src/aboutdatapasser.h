/*
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

#pragma once

#include <KAboutData>

class AboutDataPasser : public QObject
{
	Q_OBJECT
	Q_PROPERTY(KAboutData aboutData READ aboutData WRITE setAboutData)
	
public:
	explicit AboutDataPasser(QObject *parent = nullptr);
	void setAboutData(const KAboutData &aboutData);
	KAboutData aboutData() const;

private:
	KAboutData m_aboutData;
};
