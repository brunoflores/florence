#include <caml/callback.h>
#include <caml/mlvalues.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>

int fib(int n) {

  /* Initialize OCaml code */
  // caml_startup("");

  // printf("%d\n", n);

  static const value *fib_closure = NULL;
  if (fib_closure == NULL)
    fib_closure = caml_named_value("fib");
  return Int_val(caml_callback(*fib_closure, Val_int(n)));
}

char *format_result(int n) {
  static const value *format_result_closure = NULL;
  if (format_result_closure == NULL)
    format_result_closure = caml_named_value("format_result");
  return strdup(String_val(caml_callback(*format_result_closure, Val_int(n))));
  /* We copy the C string returned by String_val to the C heap
     so that it remains valid after garbage collection. */
}
