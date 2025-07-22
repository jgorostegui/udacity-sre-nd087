kubectl logs hello-world-6464549999-66mkb
Ready to receive requests on 9000
 * Serving Flask app 'main' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://10.100.1.49:9000/ (Press CTRL+C to quit)
Failed health check you want to ping /healthz
10.100.1.28 - - [25/Jun/2025 23:25:09] "GET /nginx_status HTTP/1.1" 500 -
10.100.1.28 - - [25/Jun/2025 23:25:11] "GET /nginx_status HTTP/1.1" 500 -
Failed health check you want to ping /healthz
Failed health check you want to ping /healthz
10.100.1.28 - - [25/Jun/2025 23:25:13] "GET /nginx_status HTTP/1.1" 500 -
