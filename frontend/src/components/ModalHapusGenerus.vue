<template>
  <div
    class="fixed inset-0 bg-black/70 flex items-center justify-center z-2000 p-4"
    @click.self="$emit('close')"
  >
    <div class="bg-white rounded-xl max-w-150 w-full p-6">
      <h3 class="mb-2 text-lg font-semibold">Hapus Generus</h3>

      <p class="text-sm text-gray-600 mb-4">
        Silahkan pilih alasan generus dihapus dari kelompok {{ kelompokNama }}:
      </p>

      <div class="flex flex-col gap-2">
        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="alasanHapus"
            value="Nama/Data double"
            v-model="alasanHapus"
            class="accent-blue-500"
          />
          Nama/data double.
        </label>
        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="alasanHapus"
            value="Menikah"
            v-model="alasanHapus"
            class="accent-blue-500"
          />
          Menikah.
        </label>
        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="alasanHapus"
            value="Merantau ke luar pulau"
            v-model="alasanHapus"
            class="accent-blue-500"
          />
          Merantau ke luar pulau.
        </label>

        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="alasanHapus"
            value="Pindah sambung ke luar daerah."
            v-model="alasanHapus"
            class="accent-blue-500"
          />
          Pindah sambung ke luar daerah.
        </label>

        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="alasanHapus"
            value="Pindah sambung ke kelompok lain yang masih satu daerah Tarakan."
            v-model="alasanHapus"
            class="accent-blue-500"
          />
          Pindah sambung ke kelompok lain yang masih satu daerah Tarakan.
        </label>

        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="alasanHapus"
            value="Meninggal."
            v-model="alasanHapus"
            class="accent-blue-500"
          />
          Meninggal.
        </label>

        <!-- Opsi Lainnya -->
        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="alasanHapus"
            value="Lainnya"
            v-model="alasanHapus"
            class="accent-blue-500"
          />
          Lainnya
        </label>

        <!-- Input muncul hanya jika "Lainnya" dipilih -->
        <input
          v-if="alasanHapus === 'Lainnya'"
          type="text"
          v-model="alasanLainnya"
          placeholder="Tulis alasan lainnya..."
          class="border rounded-md p-2 mt-1"
        />
      </div>

      <div class="flex flex-wrap justify-center gap-2 mt-4">
        <button
          @click="$emit('close')"
          class="px-4 py-2 rounded-md text-white font-medium bg-gray-500 hover:bg-gray-600 transition"
        >
          ✖ Tutup
        </button>

        <button
          @click="handleDelete"
          :disabled="!isValid"
          class="px-4 py-2 rounded-md text-white font-medium transition"
          :class="
            isValid
              ? 'bg-red-500 hover:bg-red-600'
              : 'bg-gray-300 cursor-not-allowed'
          "
        >
          🗑️ Hapus
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";

const emit = defineEmits(["delete", "close"]);

const props = defineProps({
  kelompokNama: String,
});

const alasanHapus = ref("");
const alasanLainnya = ref("");

// fungsi untuk emit alasan yang dipilih
const handleDelete = () => {
  let finalAlasan = alasanHapus.value;
  if (finalAlasan === "Lainnya") {
    finalAlasan = alasanLainnya.value.trim() || "Lainnya";
  }

  emit("delete", finalAlasan);
  alasanHapus.value = "";
  alasanLainnya.value = "";
  emit("close");
};

const isValid = computed(() => {
  if (!alasanHapus.value) return false;

  if (alasanHapus.value === "Lainnya") {
    return alasanLainnya.value.trim().length > 0;
  }

  return true;
});
</script>
