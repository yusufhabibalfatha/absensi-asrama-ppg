<template>
  <div class="flex items-center flex-col">
    <div className="info-content text-center">
      <div className="info-label">Tambah Generus Baru</div>
      <p class="text-xs text-red-400">
        Tambah nama generus jika belum ada didatabase.
      </p>
      <!-- <i>Tambah nama generus jika belum ada didatabase.</i> -->
      <!-- <div class="info-value">
        Tambah nama generus jika belum ada didatabase.
      </div> -->
    </div>

    <div class="flex gap-2 flex-wrap">
      <input type="text" v-model="nama_lengkap" placeholder="Nama Lengkap" />

      <input
        type="text"
        v-model="nama_panggilan"
        placeholder="Nama Panggilan"
      />

      <select v-model="jenis_kelamin">
        <option disabled value="">Jenis Kelamin</option>
        <option value="L">Laki-laki</option>
        <option value="P">Perempuan</option>
      </select>

      <button
        @click="tambahGenerus"
        :disabled="loading"
        class="p-2 border-2 bg-green-500 rounded-md"
      >
        {{ loading ? "Menambahkan..." : "Tambahkan ➕" }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

/* ========================
   Props
======================== */
const props = defineProps({
  kelompokId: {
    type: [String, Number],
    required: true,
  },
  materi: String,
});

/* ========================
   Emits
======================== */
const emit = defineEmits(["added"]);

/* ========================
   State
======================== */
const nama_lengkap = ref("");
const nama_panggilan = ref("");
const jenis_kelamin = ref("");
const loading = ref(false);

/* ========================
   Methods
======================== */
async function tambahGenerus() {
  if (!nama_lengkap.value || !jenis_kelamin.value) {
    alert("Nama lengkap dan jenis kelamin wajib diisi!");
    return;
  }

  loading.value = true;

  try {
    const res = await fetch("https://absensi.ppgtarakan.com/api/generus.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        kelompok_id: props.kelompokId,
        nama_lengkap: nama_lengkap.value,
        nama_panggilan: nama_panggilan.value,
        jenis_kelamin: jenis_kelamin.value,
      }),
    });

    const data = await res.json();

    if (data.status) {
      emit("added", data.data); // kirim ke parent

      // reset form
      nama_lengkap.value = "";
      nama_panggilan.value = "";
      jenis_kelamin.value = "";
    } else {
      alert(data.message);
    }
  } catch (err) {
    console.error(err);
    alert("Terjadi kesalahan server");
  } finally {
    loading.value = false;
  }
}
</script>
