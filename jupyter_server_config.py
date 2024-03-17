c.ServerApp.ip = "0.0.0.0"
c.ServerApp.open_browser = False
c.ServerApp.port = 8888
c.ServerApp.token = ""
c.ServerApp.password = ""
c.ServerApp.disable_check_xsrf = True
c.ServerApp.tornado_settings = {
      "headers": {
        "Content-Security-Policy": "frame-ancestors self *"
      }
    }

c.LabApp.expose_app_in_browser = True
