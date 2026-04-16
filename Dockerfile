FROM mcr.microsoft.com/playwright/python:v1.48.0-focal

WORKDIR /app

# Desactivar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar lista de paquetes con reintentos y mirror alternativo (opcional)
# También se instala build-essential (incluye gcc/g++ y más herramientas)
RUN for i in 1 2 3; do \
        apt-get update --fix-missing && break || sleep 5; \
    done && \
    apt-get install -y --no-install-recommends \
        build-essential \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Copiar archivo de dependencias de Python
COPY requirements.txt ./

# Instalar dependencias de Python en una sola capa
RUN pip install --no-cache-dir -r requirements.txt

# Instalar navegadores de Playwright y dependencias del sistema
RUN playwright install chromium && \
    playwright install-deps

# Copiar el código fuente
COPY amazon_cookie_gen.py .

# Puerto de la API
EXPOSE 8080

# Comando de inicio
CMD ["python", "amazon_cookie_gen.py"]