{{- define "octo-mesh.system-env" -}}
- name: OCTO_SYSTEM__DATABASEHOST
  value: {{ .Values.clusterDependencies.mongodbHost }}
- name: OCTO_SYSTEM__DATABASEUSERPASSWORD
  valueFrom:
    secretKeyRef:
        name: {{ printf "%s-backend" (include "octo-mesh-reporting.fullname" .) }}
        key: databaseUser
- name: OCTO_SYSTEM__ADMINUSERPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ printf "%s-backend" (include "octo-mesh-reporting.fullname" .) }}
      key: databaseAdmin          
{{- end }}

{{- define "octo-mesh.broker-env" -}}
- name: {{ printf "%s__BROKERHOST" (upper .name) }}
  value: {{ .global.Values.clusterDependencies.rabbitMqHost }}
- name: {{ printf "%s__BROKERUSER" (upper .name) }}
  value: {{ .global.Values.clusterDependencies.rabbitMqUser }}
- name: {{ printf "%s__BROKERPASSWORD" (upper .name) }}
  valueFrom:
    secretKeyRef:
      name: {{ printf "%s-backend" (include "octo-mesh-reporting.fullname" .global) }}
      key: rabbitmq     
{{- end }}

{{- define "octo-mesh.streamdata-env" -}}
- name: {{ printf "%s__STREAMDATAHOST" (upper .name) }}
  value: {{ .global.Values.clusterDependencies.streamDataHost }}
- name: {{ printf "%s__STREAMDATAUSER" (upper .name) }}
  value: {{ .global.Values.clusterDependencies.streamDataUser }}
- name: {{ printf "%s__STREAMDATAPASSWORD" (upper .name) }}
  valueFrom:
    secretKeyRef:
      name: {{ printf "%s-backend" (include "octo-mesh-reporting.fullname" .global) }}
      key: streamDataPassword     
{{- end }}


{{- define "octo-mesh.env" -}}
{{- $name := "OCTO_REPORTING" }}
{{ include "octo-mesh.system-env" . }}
{{ include "octo-mesh.broker-env" (dict "global" . "name" $name) }} 
{{ include "octo-mesh.streamdata-env" (dict "global" . "name" $name) }}
- name: OCTO_REPORTING__AUTHORITYURL
  value: {{ .Values.authUri }}
- name: OCTO_REPORTING__PUBLICURL
  value: {{ .Values.publicUri }}
{{- end }}