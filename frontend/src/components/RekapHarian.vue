<template>
  <div class="neo-box" id="rekap">
    <div
      class="flex flex-col md:flex-row md:items-center md:justify-between mb-4 gap-3"
    >
      <h2 class="text-xl font-bold text-gray-700">
        📅 Rekap Absensi Pengajian
        <span class="text-sm text-gray-500 ml-2">
          (sesi {{ selectedSesi || "Semua Sesi" }})
        </span>
      </h2>

      <div class="flex flex-col md:flex-row gap-3">
        <input
          type="date"
          v-model="selectedDate"
          @change="fetchRekap"
          class="border px-3 py-2 rounded"
        />

        <select
          v-model="selectedSesi"
          @change="fetchRekap"
          class="border px-3 py-2 rounded"
        >
          <option value="">Semua Sesi</option>
          <option value="subuh">Subuh</option>
          <option value="pagi">Pagi</option>
          <option value="siang">Siang</option>
          <option value="malam">Malam</option>
        </select>
      </div>
    </div>

    <div v-if="loadingRekap" class="text-center py-4">🔄 Memuat rekap...</div>
    <div v-if="errorRekap" class="text-center py-4 text-red-500">
      ❌ {{ errorRekap }}
    </div>

    <!-- ================= DESA BARAT ================= -->
    <div v-if="desaBarat.length" class="overflow-x-auto mb-6">
      <h3 class="font-semibold mb-2">Desa Barat</h3>
      <table class="w-full text-[10px] md:text-xs border table-auto">
        <thead class="bg-gray-100">
          <tr>
            <th class="px-2 py-1 border">Kelompok</th>
            <th class="px-2 py-1 border">Hadir</th>
            <th class="px-2 py-1 border">Izin</th>
            <th class="px-2 py-1 border">Sakit</th>
            <th class="px-2 py-1 border">Alpa</th>
            <th class="px-2 py-1 border">Terlambat</th>
            <th class="px-2 py-1 border">Total</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="item in desaBarat"
            :key="item.kelompok_id + '-' + (item.sesi || 'none')"
            :class="item.pertemuan_id ? 'bg-green-50' : 'bg-red-50'"
          >
            <td class="px-2 py-1 border">{{ item.nama_kelompok }}</td>

            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.hadir || 0 }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.izin || 0 }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.sakit || 0 }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.alpa || 0 }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.terlambat || 0 }}
            </td>

            <td class="px-2 py-1 border text-center font-bold">
              <span v-if="item.pertemuan_id">
                {{ item.total }}
              </span>
              <span v-else class="text-red-500"> Belum Absen </span>
            </td>
          </tr>
        </tbody>

        <tfoot class="bg-blue-50 font-bold">
          <tr>
            <td class="px-2 py-1 border">TOTAL DESA BARAT</td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaBarat.hadir }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaBarat.izin }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaBarat.sakit }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaBarat.alpa }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaBarat.terlambat }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaBarat.total }}
            </td>
          </tr>
        </tfoot>
      </table>
    </div>

    <!-- ================= DESA TIMUR ================= -->
    <div v-if="desaTimur.length" class="overflow-x-auto">
      <h3 class="font-semibold mb-2">Desa Timur</h3>
      <table class="w-full text-[10px] md:text-xs border table-auto">
        <thead class="bg-gray-100">
          <tr>
            <th class="px-2 py-1 border">Kelompok</th>
            <th class="px-2 py-1 border">Hadir</th>
            <th class="px-2 py-1 border">Izin</th>
            <th class="px-2 py-1 border">Sakit</th>
            <th class="px-2 py-1 border">Alpa</th>
            <th class="px-2 py-1 border">Terlambat</th>
            <th class="px-2 py-1 border">Total</th>
          </tr>
        </thead>

        <tbody>
          <tr
            v-for="item in desaTimur"
            :key="item.kelompok_id + '-' + (item.sesi || 'none')"
            :class="item.pertemuan_id ? 'bg-green-50' : 'bg-red-50'"
          >
            <td class="px-2 py-1 border">{{ item.nama_kelompok }}</td>

            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.hadir || 0 }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.izin || 0 }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.sakit || 0 }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.alpa || 0 }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ item.rekap?.terlambat || 0 }}
            </td>

            <td class="px-2 py-1 border text-center font-bold">
              <span v-if="item.pertemuan_id">
                {{ item.total }}
              </span>
              <span v-else class="text-red-500"> Belum Absen </span>
            </td>
          </tr>
        </tbody>

        <tfoot class="bg-purple-50 font-bold">
          <tr>
            <td class="px-2 py-1 border">TOTAL DESA TIMUR</td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaTimur.hadir }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaTimur.izin }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaTimur.sakit }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaTimur.alpa }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaTimur.terlambat }}
            </td>
            <td class="px-2 py-1 border text-center">
              {{ totalDesaTimur.total }}
            </td>
          </tr>
        </tfoot>
      </table>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from "vue";

const selectedDate = ref(new Date().toISOString().slice(0, 10));
const selectedSesi = ref(detectSesiOtomatis());

const rekap = ref([]);
const loadingRekap = ref(false);
const errorRekap = ref(null);

const rowClass = (item) =>
  item.pertemuan_id ? "bg-green-50 px-2 py-1" : "bg-red-50 px-2 py-1";

function detectSesiOtomatis() {
  const now = new Date();

  const jamWITA = new Intl.DateTimeFormat("en-US", {
    timeZone: "Asia/Makassar", // WITA (Tarakan)
    hour: "2-digit",
    hour12: false,
  }).format(now);

  const jam = parseInt(jamWITA);

  if (jam >= 3 && jam < 6) return "subuh";
  if (jam >= 6 && jam < 12) return "pagi";
  if (jam >= 12 && jam < 18) return "siang"; // diperpanjang sampai 18:00
  return "malam";
}

const fetchRekap = async () => {
  loadingRekap.value = true;
  errorRekap.value = null;

  try {
    const params = new URLSearchParams({ tanggal: selectedDate.value });
    if (selectedSesi.value) params.append("sesi", selectedSesi.value);

    const res = await fetch(
      `https://absensi.ppgtarakan.com/api/rekap_harian.php?${params.toString()}`,
    );
    const data = await res.json();
    console.log("🚀 ~ fetchRekap ~ data:", data);

    if (data.status) {
      rekap.value = data.data;
    } else {
      errorRekap.value = data.message;
    }
  } catch (err) {
    errorRekap.value = "Terjadi kesalahan server";
  } finally {
    loadingRekap.value = false;
  }
};

// =========================
// COMPUTED FILTER DESA
// =========================
const desaBarat = computed(() =>
  rekap.value.filter((item) => item.nama_desa.toLowerCase().includes("barat")),
);
const desaTimur = computed(() =>
  rekap.value.filter((item) => item.nama_desa.toLowerCase().includes("timur")),
);

const totalDesaBarat = computed(() => {
  const data = desaBarat.value.filter((i) => i.pertemuan_id);

  return {
    hadir: data.reduce((s, i) => s + (i.rekap?.hadir || 0), 0),
    izin: data.reduce((s, i) => s + (i.rekap?.izin || 0), 0),
    sakit: data.reduce((s, i) => s + (i.rekap?.sakit || 0), 0),
    alpa: data.reduce((s, i) => s + (i.rekap?.alpa || 0), 0),
    terlambat: data.reduce((s, i) => s + (i.rekap?.terlambat || 0), 0),
    total: data.reduce((s, i) => s + (i.total || 0), 0),
  };
});

const totalDesaTimur = computed(() => {
  const data = desaTimur.value.filter((i) => i.pertemuan_id);

  return {
    hadir: data.reduce((s, i) => s + (i.rekap?.hadir || 0), 0),
    izin: data.reduce((s, i) => s + (i.rekap?.izin || 0), 0),
    sakit: data.reduce((s, i) => s + (i.rekap?.sakit || 0), 0),
    alpa: data.reduce((s, i) => s + (i.rekap?.alpa || 0), 0),
    terlambat: data.reduce((s, i) => s + (i.rekap?.terlambat || 0), 0),
    total: data.reduce((s, i) => s + (i.total || 0), 0),
  };
});

onMounted(fetchRekap);
</script>
