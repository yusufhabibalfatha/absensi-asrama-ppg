<template>
  <div class="neo-box" style="margin-bottom: 10px">
    <div>
      <h1>Selamat Datang di Aplikasi Generus</h1>
      <p class="text-center">
        Platform digital untuk mendukung kegiatan pengajian generus dengan
        fitur-fitur yang memudahkan generus dan guru.
      </p>
    </div>
    <div class="flex justify-center gap-5 mt-4">
      <a href="#absen" class="btn btn-primary">🧑‍🏫 Mulai Absen</a>
      <a href="#rekap" class="btn btn-secondary">📊 Lihat Rekap Absen</a>
    </div>
  </div>
  <RekapHarian />
  <div class="bg-layout min-h-screen" id="absen">
    <div class="neo-box">
      <h1>Absensi Pengajian Generus Jenjang SMP, SMA, dan Mandiri.</h1>
      <p class="text-center mb-6 text-gray-700">
        Pilih kelompok yang ingin diabsen.
      </p>
      <!-- Sesi 2: Desa Barat -->
      <div class="desa-section border-accent-green pt-4 mt-8">
        <h2 class="text-xl font-bold mb-3 text-accent-green">Desa Barat</h2>
        <div v-if="loadingBarat" class="text-center py-4">
          🔄 Memuat daftar kelompok...
        </div>
        <div v-if="errorBarat" class="text-center py-4 text-red-500">
          ❌ {{ errorBarat }}
          <button @click="fetchKelompok(1)" class="btn btn-primary ml-2">
            Coba Lagi
          </button>
        </div>
        <div
          v-if="kelompokBarat.length"
          class="grid grid-cols-2 md:grid-cols-3 gap-4"
        >
          <div
            v-for="k in kelompokBarat"
            :key="k.id"
            @click="goToAbsensi(k.id, k.nama)"
            class="kelompok-card max-sm:text-sm"
          >
            {{ k.nama }}
          </div>
        </div>
        <div v-else-if="!loadingBarat" class="text-center py-4">
          📭 Tidak ada kelompok tersedia
        </div>
      </div>
      <!-- Sesi 1: Desa Timur -->
      <div class="desa-section border-primary-blue pt-4 mt-6">
        <h2 class="text-xl font-bold mb-3 text-primary-blue">Desa Timur</h2>
        <div v-if="loadingTimur" class="text-center py-4">
          🔄 Memuat daftar kelompok...
        </div>
        <div v-if="errorTimur" class="text-center py-4 text-red-500">
          ❌ {{ errorTimur }}
          <button @click="fetchKelompok(2)" class="btn btn-primary ml-2">
            Coba Lagi
          </button>
        </div>
        <div
          v-if="kelompokTimur.length"
          class="grid grid-cols-2 md:grid-cols-3 gap-4"
        >
          <div
            v-for="k in kelompokTimur"
            :key="k.id"
            @click="goToAbsensi(k.id, k.nama)"
            class="kelompok-card max-sm:text-sm"
          >
            {{ k.nama }}
          </div>
        </div>
        <div v-else-if="!loadingTimur" class="text-center py-4">
          📭 Tidak ada kelompok tersedia
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import RekapHarian from "@/components/RekapHarian.vue";

const router = useRouter();

const kelompokTimur = ref([]);
const kelompokBarat = ref([]);
const loadingTimur = ref(false);
const loadingBarat = ref(false);
const errorTimur = ref(null);
const errorBarat = ref(null);

const fetchKelompok = async (desa_id) => {
  const loading = desa_id === 2 ? loadingTimur : loadingBarat;
  const error = desa_id === 2 ? errorTimur : errorBarat;
  const kelompok = desa_id === 2 ? kelompokTimur : kelompokBarat;

  loading.value = true;
  error.value = null;

  try {
    const res = await fetch(
      `https://absensi.ppgtarakan.com/api/kelompok.php?desa_id=${desa_id}`,
    );
    const data = await res.json();

    if (data.status) {
      kelompok.value = data.data;
    } else {
      error.value = data.message || "Gagal memuat data";
    }
  } catch (err) {
    error.value = err.message || "Terjadi kesalahan server";
  } finally {
    loading.value = false;
  }
};

const goToAbsensi = (id, nama) => {
  router.push({
    name: "Absensi",
    query: { nama: nama, kelompok_id: id },
  });
};

onMounted(() => {
  fetchKelompok(2);
  fetchKelompok(1);
});
</script>
