#!/bin/bash
set -e
PROJECT_DIR=~/JSP\ L3/MedRDV

echo "🛑 Arrêt de Tomcat..."
$CATALINA_HOME/bin/shutdown.sh 2>/dev/null || true
sleep 4

echo "🧹 Nettoyage cache..."
sudo rm -rf /opt/tomcat/work/Catalina/localhost/MedRDV
rm -rf /opt/tomcat/webapps/MedRDV
rm -f  /opt/tomcat/webapps/MedRDV.war

echo "📦 Compilation Maven..."
cd "$PROJECT_DIR"
mvn clean package -q

echo "🚀 Déploiement..."
cp "$PROJECT_DIR/target/MedRDV.war" /opt/tomcat/webapps/
$CATALINA_HOME/bin/startup.sh
sleep 6

echo "🔑 Permissions..."
sudo chown -R tokiniaina:tokiniaina /opt/tomcat/webapps/MedRDV
sudo chmod -R 755 /opt/tomcat/webapps/MedRDV

echo "✅ Résultat :"
curl -s -o /dev/null -w "HTTP %{http_code}\n" http://localhost:8090/MedRDV/
