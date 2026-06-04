cmake_minimum_required(VERSION 3.22)

set(PROJECT_NAME evkbimxrt1050_hello_world)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

enable_language(ASM)

project(${PROJECT_NAME} C CXX ASM)

#---Set system configuration
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

#----Project and sdk path
set(PROJECT_PATH /workspace/project/evkbimxrt1050_hello_world)
set(SDK_PATH /workspace/sdk/SDK_25_06_00_EVKB-IMXRT1050)
set(LINKER_PATH /workspace/sdk/SDK_25_06_00_EVKB-IMXRT1050/devices/MIMXRT1052/gcc)
set(SYSTEM_MCU_PATH /workspace/sdk/SDK_25_06_00_EVKB-IMXRT1050/devices/MIMXRT1052)

# CPU / FPU settings
set(MCPU cortex-m7)
set(MFPU fpv5-d16)
set(MFLOAT_ABI hard)

# Toolchain
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# Compiler flags
set(COMMON_FLAGS "-mcpu=${MCPU} -mthumb -mfpu=${MFPU} -mfloat-abi=${MFLOAT_ABI}")
set(CMAKE_C_FLAGS "${COMMON_FLAGS} -O0 -g3 -ffunction-sections -fdata-sections -Wall") # -fno-common -fno-builtin")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")
set(CMAKE_ASM_FLAGS "${COMMON_FLAGS} -x assembler-with-cpp")

#----add source files
file(GLOB SRC_FILES
	${PROJECT_PATH}/board/*.c
	${PROJECT_PATH}/CMSIS/*.c   #NO ANY SOURCE FILE 
	${PROJECT_PATH}/CMSIS/m-profile/*.c
	${PROJECT_PATH}/component/uart/*.c
	${PROJECT_PATH}/device/*.c
	${PROJECT_PATH}/device/periph/*.c
	${PROJECT_PATH}/drivers/*.c
	${PROJECT_PATH}/source/*.c
#	${PROJECT_PATH}/startup/*.c
#	${SYSTEM_MCU_PATH}/system_MIMXRT1052.c
	${PROJECT_PATH}/utilities/*.c
	${PROJECT_PATH}/utilities/str/*.c
	${PROJECT_PATH}/utilities/debug_console_lite/*.c
	${PROJECT_PATH}/xip/*.c
)

#----Compiler definitions

add_compile_definitions(
	CPU_MIMXRT1052DVL6B
	CPU_MIMXRT1052DVL6B_cm7
	MCUXPRESSO_SDK
	XIP_BOOT_HEADER_ENABLE=1
	XIP_EXTERNAL_FLASH=1
	SDK_DEBUGCONSOLE=1
	MCUX_META_BUILD
	MIMXRT1052_SERIES
	CR_INTEGER_PRINTF
	#PRINTF_FLOAT_ENABLE=0
	__MCUXPRESSO
	__USE_CMSIS
	DEBUG
	ARM_MATH_CM7
	__FPU_PRESENT=1
)

#-----Include directories---
include_directories(
	${PROJECT_PATH}/source
	${PROJECT_PATH}/xip
	${SDK_PATH}/
	${PROJECT_PATH}/drivers
	${PROJECT_PATH}/CMSIS
	${PROJECT_PATH}/CMSIS/m-profile
	${PROJECT_PATH}/device
	${SYSTEM_MCU_PATH}
	${PROJECT_PATH}/device/periph
	${PROJECT_PATH}/utilities
	${PROJECT_PATH}/utilities/str
	${PROJECT_PATH}/utilities/debug_console_lite
	${PROJECT_PATH}/board
	${PROJECT_PATH}/component/uart
	${PROJECT_PATH}/startup
)

add_executable(${PROJECT_NAME}.elf
	${SRC_FILES}
	${LINKER_PATH}/startup_MIMXRT1052.S
)

target_link_options(${PROJECT_NAME}.elf	PRIVATE
	-T${LINKER_PATH}/MIMXRT1052xxxxx_flexspi_nor.ld
	-specs=nosys.specs
	-Wl,-Map=${PROJECT_NAME}.map
	-Wl,--gc-section

    # --- Vector table chain ---
    -Wl,--defsym=g_pfnVectors=__Vectors
    -Wl,--defsym=__VECTOR_TABLE=g_pfnVectors
    -Wl,--undefined=g_pfnVectors

    # --- Non cache region ---
    -Wl,--defsym=__base_NCACHE_REGION=0x81E00000
    -Wl,--defsym=__top_NCACHE_REGION=0x82000000
)


# =============================
# Post-build: bin & hex
# =============================
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND arm-none-eabi-objcopy -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    COMMAND arm-none-eabi-objcopy -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
)
