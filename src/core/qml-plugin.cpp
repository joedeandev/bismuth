// SPDX-FileCopyrightText: 2022 Mikhail Zolotukhin <mail@genda.life>
// SPDX-License-Identifier: MIT

#include "qml-plugin.hpp"

#include <QJSValue>
#include <QString>
#include <QtQml>

#include <memory>

#include "config.hpp"
#include "plasma-api/plasma-api.hpp"
#include "ts-proxy.hpp"

void CorePlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.bismuth.core"));
    qmlRegisterModule(uri, 1, 0);

    qmlRegisterType<Core>(uri, 1, 0, "Core");
}

Core::Core(QQuickItem *parent)
    : QQuickItem(parent)
    , m_engine() // We cannot get engine from the pointer in the constructor
    , m_plasmaApi()
    , m_tsProxy()
    , m_config(std::make_unique<Bismuth::Config>())
{
}

void Core::init()
{
    m_engine = qmlEngine(this);
    if (m_config->debug()) {
        qDebug() << "[Bismuth] Core QmlEngine ptr: " << m_engine;
    }
    m_plasmaApi = std::make_unique<PlasmaApi::PlasmaApi>(m_engine);
    m_tsProxy = std::make_unique<TSProxy>(m_engine, *m_config);
}

TSProxy *Core::tsProxy() const
{
    return m_tsProxy.get();
}
