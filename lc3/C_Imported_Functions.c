#include <inttypes.h>
#include <stdio.h>

static char trace_file_name[] = "trace_data.dat";
static FILE *trace_file_stream;

uint32_t c_trace_file_open(uint8_t dummy) {
  uint32_t success = 0;
  trace_file_stream = fopen("trace_out.dat", "w");
  if (trace_file_stream == NULL) {
    fprintf(stderr, "ERROR: c_trace_file_open: unable to open file '%s'.\n",
            trace_file_name);
    success = 0;
  } else {
    fprintf(stdout, "c_trace_file_stream: opened file '%s' for trace_data.\n",
            trace_file_name);
    success = 1;
  }
  return success;
}
