# Simple React User Lookup

Aplicación mínima en React que consulta el endpoint `http://localhost:8081/api/users` filtrando por prefijo.

## Requisitos

- Node.js 18 o superior
- Backend disponible en `http://localhost:8081`

## Configuración de variables

El backend se configura mediante `VITE_API_BASE_URL` o, si prefieres el nombre original, `VITE_API_USER_ORIGIN`. Ambas son equivalentes y puedes definirlas en `.env` o en un `.env.local` (ya ignorado por git):

```
VITE_API_BASE_URL=http://localhost:8081
VITE_API_USER_ORIGIN=http://localhost:8081
```

## Pasos para ejecutar

1. Instala las dependencias:

   ```bash
   npm install
   ```

2. Inicia el entorno de desarrollo:

   ```bash
   npm run dev
   ```

3. Abre el navegador en la URL indicada por Vite (por defecto `http://localhost:3000`).

4. Ingresa un prefijo en la caja de texto (por defecto está precargado con `sa`) y presiona **Consultar** para ver los resultados.

## Build para producción

```bash
npm run build
npm run preview
```

`npm run preview` sirve los archivos generados en `dist/` para validarlos de manera local.

## Docker

Construir la imagen:

```bash
docker build -t simple-react-app .
```

Ejecutar el contenedor (expone el puerto por defecto 4173):

```bash
docker run -p 4173:4173 --env VITE_API_BASE_URL=http://tu-backend:8081 simple-react-app
# …o usando la variable alternativa
docker run -p 4173:4173 --env VITE_API_USER_ORIGIN=http://tu-backend:8081 simple-react-app
```

Si necesitas otra URL para el backend, ajusta cualquiera de esas variables en tiempo de ejecución o define el valor antes de construir la imagen.

## Helm & CI/CD

- El chart para Kubernetes vive en `helm/frontend-users` e incluye despliegue, Service, Ingress opcional y HPA. Ajusta `values.yaml` o pasa `--set`/`-f` con `config.apiBaseUrl` y parámetros de imagen.
- Para exponer el servicio en OpenShift puedes habilitar `route.enabled=true` (y opcionalmente definir `route.host`, `route.termination` e `route.insecurePolicy`) o bien usar el Ingress estándar del cluster.
- El pipeline de GitHub Actions (`.github/workflows/frontend-ci-cd.yml`) construye la app, arma la imagen, la publica y ejecuta `helm upgrade --install`. Requiere secretos: `REGISTRY_HOST`, `REGISTRY_NAMESPACE`, `REGISTRY_USERNAME`, `REGISTRY_PASSWORD`, `FRONTEND_API_BASE_URL`, `OPENSHIFT_SERVER`, `OPENSHIFT_TOKEN`, `OPENSHIFT_NAMESPACE` y opcionalmente `OPENSHIFT_SKIP_TLS_VERIFY`.
