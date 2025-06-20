class Modal {

  // optoonal paremeter but has default title, message , ok label on clsoe 
  static void success({String title = "Success", String message = "Operation completed successfully", String okLabel = "OK"}) {
   
  }

// use to display all error
  static void error({String title = "Error", String message = "Operation failed", String okLabel = "OK"}) {
   
  }

  // use to every action that has confirmation
  static void confirm({String title = "Confirm", String message = "Are you sure you want to perform this action?", String okLabel = "OK", String cancelLabel = "Cancel"}) {
   
  }

  


}