#include "config.h"
#include "ui_config.h"

Config::Config(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::Config)
{
	ui->setupUi(this);
}

QString Config::getPort() {
	return this->ui->port->text();
}

QString Config::getServer() {
	return this->ui->server->text();
}

Config::~Config()
{
	delete ui;
}
