<template>
  <form
    @submit.prevent="submitForm"
    class="mb-6 p-4 border rounded shadow bg-gray-50"
  >
    <h3 class="font-semibold mb-2">➕ Tambah Generus Baru</h3>
    <div class="flex gap-2 flex-wrap">
      <input
        type="text"
        v-model="nama_lengkap"
        placeholder="Nama Lengkap"
        required
        class="border p-2 rounded flex-1"
      />
      <input
        type="text"
        v-model="nama_panggilan"
        placeholder="Nama Panggilan (optional)"
        class="border p-2 rounded flex-1"
      />
      <select v-model="jenis_kelamin" required class="border p-2 rounded">
        <option disabled value="">Jenis Kelamin</option>
        <option value="L">Laki-laki</option>
        <option value="P">Perempuan</option>
      </select>
      <button type="submit" class="bg-green-600 text-white px-4 py-2 rounded">
        Tambah
      </button>
    </div>
  </form>
</template>

<script>
import { ref } from "vue";

export default {
  props: ["kelompokId"],
  emits: ["generus-added"],
  setup(props, { emit }) {
    const nama_lengkap = ref("");
    const nama_panggilan = ref("");
    const jenis_kelamin = ref("");

    const submitForm = async () => {
      const API_URL = import.meta.env.VITE_API_URL || "http://localhost/api";

      const payload = {
        nama_lengkap: nama_lengkap.value,
        nama_panggilan: nama_panggilan.value,
        jenis_kelamin: jenis_kelamin.value,
        kelompok_id: props.kelompokId,
      };
      try {
        const res = await fetch(`${API_URL}/api/generus`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });
        const data = await res.json();
        if (data.status) {
          emit("generus-added", data.data);
          nama_lengkap.value = "";
          nama_panggilan.value = "";
          jenis_kelamin.value = "";
        }
      } catch (err) {
        console.error(err);
      }
    };

    return { nama_lengkap, nama_panggilan, jenis_kelamin, submitForm };
  },
};
</script>
