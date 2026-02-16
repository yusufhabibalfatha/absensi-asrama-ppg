<template>
  <div
    class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50"
  >
    <div class="bg-white p-4 rounded w-full max-w-md">
      <h3 class="font-bold mb-2">📝 Tambah Keterangan</h3>
      <textarea
        v-model="localKeterangan"
        class="w-full border p-2 rounded mb-2"
        rows="4"
      ></textarea>
      <p class="text-sm text-gray-500 mb-4">Contoh: {{ contohKeterangan }}</p>
      <div class="flex gap-2 justify-end">
        <button
          class="bg-gray-500 text-white px-3 py-1 rounded"
          @click="$emit('close')"
        >
          ✖ Tutup
        </button>
        <button class="bg-blue-600 text-white px-3 py-1 rounded" @click="save">
          💾 Simpan
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed } from "vue";

export default {
  props: ["status", "currentKeterangan"],
  emits: ["save", "close"],
  setup(props, { emit }) {
    const localKeterangan = ref(props.currentKeterangan || "");

    const contohKeterangan = computed(() => {
      switch (props.status) {
        case "Izin":
          return "pulang lebih awal, ada keperluan keluarga, izin sakit";
        case "Sakit":
          return "demam, batuk pilek, sakit perut";
        case "Alpa":
          return "tidak ada kabar, terlambat terlalu lama, bolos";
        case "Hadir":
          return "hadir tepat waktu, hadir terlambat 15 menit";
        case "Terlambat":
          return "hadir terlambat 30 menit, hadir terlambat 1 jam";
        default:
          return "tulis keterangan tambahan...";
      }
    });

    const save = () => emit("save", localKeterangan.value);

    return { localKeterangan, contohKeterangan, save };
  },
};
</script>
