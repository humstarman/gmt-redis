apiVersion: v1
kind: Service
metadata:
  namespace: {{.namespace}}
  labels:
    component: {{.name}} 
    {{.labels.key}}: {{.labels.value}}
  name: {{.name}}
spec:
  clusterIP: None 
  selector:
    component: {{.name}}
  ports:
    - port: 6379 
      targetPort: 6379 
      name: redis 
