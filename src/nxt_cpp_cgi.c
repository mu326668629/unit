#include <nxt_main.h>
#include <nxt_runtime.h>
#include <nxt_router.h>
#include <nxt_unit.h>
#include <nxt_unit_field.h>
#include <nxt_unit_request.h>
#include <nxt_unit_response.h>


static nxt_int_t nxt_cpp_start(nxt_task_t *task,
    nxt_process_data_t *data);


static uint32_t  compat[] = {
    NXT_VERNUM, NXT_DEBUG,
};


NXT_EXPORT nxt_app_module_t  nxt_app_module = {
    sizeof(compat),
    compat,
    nxt_string("cpp"),
    "1.0.0",
    NULL,
    0,
    NULL,
    nxt_cpp_start,
};


static nxt_int_t
nxt_cpp_start(nxt_task_t *task, nxt_process_data_t *data) {
    nxt_log(task, NXT_LOG_INFO, "errmsg");
    return NXT_ERROR;
}