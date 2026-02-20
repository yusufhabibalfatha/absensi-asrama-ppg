<template>
  <div class="neo-box mt-10" id="activity-log">
    <div class="flex justify-between items-center mb-4">
      <h1>📜 Activity Log</h1>
      <button @click="fetchLogs" class="btn btn-primary">🔄 Refresh</button>
    </div>

    <div v-if="loading" class="text-center py-6">
      🔄 Memuat data aktivitas...
    </div>

    <div v-if="error" class="text-center text-red-500 py-4">❌ {{ error }}</div>

    <!-- TABLE WRAPPER -->
    <div v-if="logs.length" class="border rounded-lg overflow-hidden">
      <div class="max-h-100 overflow-y-auto">
        <table class="min-w-full border-collapse">
          <thead class="bg-gray-100 sticky top-0">
            <tr class="text-left">
              <th class="p-3">Kelompok</th>
              <th class="p-3">Aksi</th>
              <th class="p-3">Generus ID</th>
              <th class="p-3">Waktu</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="log in logs"
              :key="log.id"
              class="border-b hover:bg-gray-50"
            >
              <td class="p-3 font-semibold">
                {{ log.nama_kelompok }}
              </td>
              <td class="p-3">
                {{ log.aksi }}
              </td>
              <td class="p-3">
                {{ log.record_id || "-" }}
              </td>
              <td class="p-3 text-sm text-gray-600">
                {{ formatDate(log.created_at) }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- PAGINATION -->
      <div class="flex justify-between items-center p-3 bg-gray-50">
        <button
          @click="changePage(page - 1)"
          :disabled="page === 1"
          class="btn btn-secondary"
        >
          ⬅ Prev
        </button>

        <div>Halaman {{ page }} dari {{ totalPages }}</div>

        <button
          @click="changePage(page + 1)"
          :disabled="page === totalPages"
          class="btn btn-secondary"
        >
          Next ➡
        </button>
      </div>
    </div>

    <div v-else-if="!loading" class="text-center py-6">
      📭 Belum ada aktivitas tercatat
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";

const logs = ref([]);
const loading = ref(false);
const error = ref(null);

const page = ref(1);
const perPage = 20;
const totalPages = ref(1);

const fetchLogs = async () => {
  loading.value = true;
  error.value = null;

  try {
    const url = `https://absensi.ppgtarakan.com/api/activity_logs.php?page=${page.value}&per_page=${perPage}`;
    console.log("🚀 ~ fetchLogs ~ url:", url);
    const res = await fetch(url);

    const data = await res.json();

    if (data.status) {
      logs.value = data.data;
      totalPages.value = data.meta.total_pages;
    } else {
      error.value = data.message || "Gagal memuat data";
    }
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

const changePage = (newPage) => {
  if (newPage < 1 || newPage > totalPages.value) return;
  page.value = newPage;
  fetchLogs();
};

const formatDate = (dateStr) => {
  return new Date(dateStr).toLocaleString("id-ID");
};

onMounted(() => {
  fetchLogs();
});
</script>
