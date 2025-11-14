#!/bin/sh
set -e
echo "===================================="
echo " 🚀 Ejabberd post-start provisioning "
echo "===================================="

# 1️⃣ Wait for PostgreSQL
echo "⏳ Waiting for PostgreSQL to be ready..."
until docker exec -it ejabberd_db pg_isready -U ejabberd >/dev/null 2>&1; do
  sleep 2
done
echo "✅ Database ready."

# 2️⃣ Wait for Ejabberd
echo "⏳ Waiting for Ejabberd service..."
until docker exec ${EJABBERD_CONTAINER} ejabberdctl status >/dev/null 2>&1; do
  sleep 3
done
echo "✅ Ejabberd is running."

# 3️⃣ Create admin if not exists
echo "🔍 Checking admin account..."

if docker exec ${EJABBERD_CONTAINER} ejabberdctl check_password ${ADMIN_NAME} ${EJABBERD_DOMAIN} ${ADMIN_PASS} >/dev/null 2>&1; then
  echo "✅ Admin user already exists."
else
  echo "⚙️ Creating admin user..."
  docker exec ${EJABBERD_CONTAINER} ejabberdctl register admin ${EJABBERD_DOMAIN} ${ADMIN_PASS}
  echo "✅ Admin account created."

fi

# 4️⃣ Verify JWT key exists
echo "🔑 Checking JWT key..."
if docker exec ${EJABBERD_CONTAINER} test -f "${JWT_KEY_PATH}"; then
  echo "✅ JWT key found at ${JWT_KEY_PATH}"
else
  echo "❌ JWT key missing inside Ejabberd container!"
  exit 1
fi

# 5️⃣  Reload Ejabberd configuration
echo "♻️ Reloading Ejabberd to pick up new JWT key and modules..."
docker exec ${EJABBERD_CONTAINER} ejabberdctl reload_config
echo "✅ Ejabberd configuration reloaded."

echo "✅ All provisioning complete."
