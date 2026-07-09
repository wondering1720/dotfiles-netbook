#!/bin/bash

# 1. Matar procesos previos silenciosamente (si no existen, no pasa nada)
killall jackd 2>/dev/null
killall guitarix 2>/dev/null

echo "Iniciando el motor de audio JACK..."

# 2. Arrancar JACK con parámetros de alto rendimiento
# Tip de ingeniero: Si usas una interfaz USB, puedes cambiar "alsa" por "alsa -d hw:USB" o el nombre de tu tarjeta.
jackd -R -d alsa -r 44100 -p 128 -n 3 -d hw:USB &

# 3. Esperar a que el servidor de sonido se estabilice
sleep 3

echo "Lanzando amplificador virtual Guitarix..."
# 4. Lanzar Guitarix en segundo plano
guitarix &

echo "--------------------------------------------------------"
echo "¡Entorno de audio listo! Conecta tus cables en qjackctl si es necesario."
echo "--------------------------------------------------------"