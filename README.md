# AspNetDockerAppAKS
Proyecto para ejecución de IaC y CI CD de aplicación ASP.NET en AKS.

Se requiere diseñar una solución de Integración y Despliegue Continuo para una aplicación ASP.NET que se ejecutará contenerizada en un clúster de AKS.

Se requiere automatizar la infraestructura para el proyecto con un pipeline en ADS.
Se debe contenerizar la aplicación con Docker y tener disponible el versionamiento de dicha imagen en un ACR.
El proceso debe ejecutarse todo en un sólo Pipeline Multistage, con una aprobación manual que permita dar inicio al deployment en ADS.
Se debe configurar el disparador del Pipeline para que inicie de manera automática una vez  se ejecute un commit en la rama.
El pipeline debe publicar el artefacto que se usará para desplegar el contenedor en K8s

**ARTICULO COMPLETO:**  [Ir al artículo](https://dubercoder.com/integracion-y-despliegue-continuo-en-azure-pipelines-de-una-aplicacion-asp-net-contenerizada-con-docker-en-azure-kubernetes-service-en-construccion/). <br>

**SOLUCIÓN**  <br>
**El siguiente video muestra la metodología y el proceso de principio a fin para la ejecución de todos los requerimientos.**  <br>
 <br>
https://youtu.be/F3NhLG5mWx8
