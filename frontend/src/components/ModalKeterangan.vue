<template>
  <div
    class="fixed inset-0 bg-black/70 flex items-center justify-center z-2000 p-4"
    @click.self="$emit('close')"
  >
    <div class="bg-white rounded-xl max-w-150 w-full p-6">
      <h3 class="mb-2 text-lg font-semibold">📝 Tambah Keterangan</h3>

      <textarea
        v-model="keterangan"
        placeholder="Tulis keterangan tambahan..."
        class="w-full min-h-62.5 mb-4 p-3 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400"
      ></textarea>

      <p class="mb-4 text-sm text-gray-600">Contoh: {{ contoh }}</p>

      <p class="text-sm text-gray-600 mb-4">
        Silahkan tekan "Simpan" untuk menyimpan keterangan.
      </p>

      <div class="flex flex-wrap justify-center gap-2">
        <button
          @click="$emit('close')"
          class="px-4 py-2 rounded-md text-white font-medium bg-gray-500 hover:bg-gray-600 transition"
        >
          ✖ Tutup
        </button>

        <button
          @click="save"
          class="px-4 py-2 rounded-md text-white font-medium bg-indigo-500 hover:bg-indigo-600 transition"
        >
          💾 Simpan
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from "vue";

/* ========================
   Props
======================== */
const props = defineProps({
  initial: String,
  contoh: String,
});

/* ========================
   Emits
======================== */
const emit = defineEmits(["save", "close"]);

/* ========================
   State
======================== */
const keterangan = ref(props.initial || "");

/* ========================
   Watch (agar update kalau initial berubah)
======================== */
watch(
  () => props.initial,
  (newVal) => {
    keterangan.value = newVal || "";
  },
);

/* ========================
   Methods
======================== */
function save() {
  emit("save", keterangan.value);
  keterangan.value = "";
}
</script>
