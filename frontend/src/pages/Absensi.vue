<template>
  <div>
    <div class="navigation-controls">
      <h1 class="absensi-header">📋 Halaman Absensi</h1>
      <button @click="goBack" class="nav-button btn-back">← Kembali</button>
    </div>

    <div class="info-card">
      <div class="info-item">
        <div class="info-icon">🗓️</div>
        <div class="info-content">
          <div class="info-label">Tanggal</div>
          <p>{{ tanggalFormatIndonesia }}</p>
        </div>
        <div>
          <input type="date" v-model="tanggalDipilih" />
        </div>
      </div>

      <div class="info-item">
        <div class="info-icon">🕗</div>
        <div class="info-content">
          <div class="info-label">Sesi</div>
          <p>{{ sesi }}</p>
        </div>
        <select v-model="sesi">
          <option v-for="item in daftarSesi" :key="item" :value="item">
            {{ item.charAt(0).toUpperCase() + item.slice(1) }}
          </option>
        </select>
      </div>

      <div class="info-item">
        <div class="info-icon">📖</div>
        <div class="info-content">
          <div class="info-label">Materi</div>
          <div class="info-value">{{ materi }}</div>
        </div>
        <input
          type="text"
          v-model="materi"
          placeholder="Masukkan materi hari ini..."
        />
      </div>

      <div className="info-item teacher-info">
        <div className="info-icon">🕌</div>
        <div className="info-content">
          <div className="info-label">Kelompok</div>
          <div className="info-value">
            {{ kelompokNama }}
          </div>
        </div>
        <span className="status-badge status-active">Active</span>
      </div>

      <FormTambahGenerus
        :kelompokId="kelompokId"
        @added="addGenerus"
        :materi="materi"
      />
    </div>

    <AbsensiStats :stats="stats" />

    <h2
      :style="{
        color: '#000',
        textAlign: 'center',
        marginBottom: '1.5rem',
        fontSize: '1.5rem',
        fontWeight: '700',
      }"
    >
      👥 Terdaftar {{ generusList.length }} Generus
    </h2>

    <!-- absen generus -->
    <div
      v-for="g in generusList"
      :key="g.id"
      class="relative bg-white border-[3px] border-black rounded-xl p-6 mb-4 transition-all duration-300"
      :class="cardBorder(g.status)"
    >
      <div
        class="flex flex-col md:flex-row md:items-center md:justify-between gap-4"
      >
        <!-- Nama + Badge -->
        <div class="flex flex-wrap items-center gap-3 flex-1">
          <p
            class="text-lg font-bold px-4 py-2 rounded-lg transition-all duration-300"
            :class="namaStyle(g.status)"
          >
            {{ g.nama_lengkap }}

            <span
              v-if="g.status"
              class="ml-2 text-xs font-bold px-2 py-1 rounded-full text-white"
              :class="badgeStyle(g.status)"
            >
              {{ g.status.toUpperCase() }}
            </span>
          </p>

          <!-- Keterangan badge -->
          <span
            v-if="g.keterangan"
            @click="openKeterangan(g)"
            class="px-3 py-1 text-xs font-medium border-2 border-sky-700 text-sky-700 bg-sky-50 rounded-full cursor-pointer transition hover:-translate-y-0.5 hover:shadow-[1px_1px_0_#0369a1]"
          >
            📝
            {{
              g.keterangan.length > 20
                ? g.keterangan.substring(0, 20) + "..."
                : g.keterangan
            }}
          </span>

          <!-- Batalkan -->
          <button
            v-if="g.status"
            @click="
              g.status = null;
              g.keterangan = null;
            "
            class="bg-red-500 text-white border-2 border-black rounded-md px-3 py-1 text-xs font-bold shadow-[1px_1px_0_black] transition hover:-translate-x-0.5 hover:-translate-y-0.5 hover:shadow-[2px_2px_0_black]"
          >
            ❌ Batalkan
          </button>
        </div>

        <!-- Status Options -->
        <div class="flex flex-wrap gap-2 justify-center md:justify-end">
          <label
            v-for="status in statusOptions"
            :key="status"
            class="relative cursor-pointer uppercase text-sm font-bold tracking-wide px-4 py-2 border-2 border-black rounded-md transition-all"
            :class="statusButton(g.status, status)"
          >
            <input
              type="radio"
              :name="'status-' + g.id"
              :value="status"
              v-model="g.status"
              class="hidden"
            />

            {{ status }}

            <button
              v-if="g.status === status"
              type="button"
              @click.stop="openKeterangan(g)"
              class="ml-2 text-xs hover:scale-110 transition"
            >
              {{ g.keterangan ? "📝" : "✏️" }}
            </button>
          </label>
        </div>
      </div>
    </div>

    <button
      @click="submitAbsensi"
      :disabled="submitLoading"
      class="btn submit-button"
    >
      {{ submitLoading ? "Mengirim..." : "📥 Bagikan ke WhatsApp" }}
    </button>

    <ModalKeterangan
      v-if="modalKeteranganOpen"
      :initial="editingKeterangan?.keterangan"
      :contoh="getKeteranganContoh(editingKeterangan?.status)"
      @save="saveKeterangan"
      @close="modalKeteranganOpen = false"
    />

    <div
      v-if="whatsappMessage"
      class="fixed inset-0 bg-black/70 flex items-center justify-center z-2000 p-4"
      @click.self="whatsappMessage = ''"
    >
      <div class="bg-white rounded-xl max-w-150 w-full p-6">
        <h3 class="mb-2 text-lg font-semibold">📤 Preview Pesan WhatsApp</h3>

        <textarea
          readonly
          class="w-full min-h-62.5 mb-4 p-3 text-sm border border-gray-300 rounded-md focus:outline-none"
          >{{ whatsappMessage }}</textarea
        >

        <p class="text-sm text-gray-600 mb-4">
          Silahkan tekan "Salin Teks" jika tombol "Kirim ke WhatsApp" tidak
          berfungsi, lalu paste manual ke dalam grup WhatsApp.
        </p>

        <div class="flex flex-wrap justify-center gap-2">
          <button
            @click="copyToClipboard"
            class="px-4 py-2 rounded-md text-white font-medium bg-indigo-500 hover:bg-indigo-600 transition"
          >
            📋 Salin Teks
          </button>

          <button
            @click="sendToWhatsapp"
            class="px-4 py-2 rounded-md text-white font-medium bg-green-500 hover:bg-green-600 transition"
          >
            📤 Kirim ke WhatsApp
          </button>

          <button
            @click="whatsappMessage = ''"
            class="px-4 py-2 rounded-md text-white font-medium bg-gray-500 hover:bg-gray-600 transition"
          >
            ✖ Tutup
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";

import FormTambahGenerus from "../components/FormTambahGenerus.vue";
import AbsensiStats from "../components/AbsensiStats.vue";
import ModalKeterangan from "../components/ModalKeterangan.vue";

/* ========================
   State
======================== */
const route = useRoute();
const router = useRouter();

function goBack() {
  router.push({ name: "Home" });
}

const kelompokNama = ref(route.query.nama || "");
const kelompokId = ref(route.query.kelompok_id || "");
const generusList = ref([]);
const statusOptions = ["Hadir", "Terlambat", "Izin", "Sakit", "Alpa"];

const modalKeteranganOpen = ref(false);
const editingKeterangan = ref(null);

const submitLoading = ref(false);
const whatsappMessage = ref("");

/* ========================
   Computed
======================== */
const stats = computed(() => {
  const result = {
    Hadir: 0,
    Terlambat: 0,
    Izin: 0,
    Sakit: 0,
    Alpa: 0,
    Belum: 0,
  };

  generusList.value.forEach((g) => {
    if (!g.status) result.Belum++;
    else result[g.status]++;
  });

  return result;
});

/* ========================
   Lifecycle
======================== */
onMounted(() => {
  fetchGenerus();
  sesi.value = detectSesiOtomatis();
});

/* ========================
   Methods
======================== */
async function fetchGenerus() {
  try {
    const res = await fetch(
      `https://absensi.ppgtarakan.com/api/generus.php?kelompok_id=${kelompokId.value}`,
    );
    const data = await res.json();

    if (data.status) {
      generusList.value = data.data.map((g) => ({
        ...g,
        status: null,
        keterangan: null,
      }));
    }
  } catch (err) {
    console.error(err);
    alert("Gagal memuat data generus");
  }
}

function addGenerus(newGenerus) {
  generusList.value = [
    {
      ...newGenerus,
      status: null,
      keterangan: null,
    },
    ...generusList.value,
  ];
}

function openKeterangan(g) {
  editingKeterangan.value = g;
  modalKeteranganOpen.value = true;
}

function saveKeterangan(ket) {
  if (editingKeterangan.value) {
    editingKeterangan.value.keterangan = ket;
  }
  modalKeteranganOpen.value = false;
}

function getKeteranganContoh(status) {
  switch (status) {
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
}

function generateWhatsappMessage() {
  const today = new Date();
  const tanggalLengkap = today.toLocaleDateString("id-ID", {
    weekday: "long",
    day: "numeric",
    month: "long",
    year: "numeric",
  });

  // Kategori absensi
  const groups = {
    Hadir: [],
    Terlambat: [],
    Izin: [],
    Sakit: [],
    Alpa: [],
  };

  generusList.value.forEach((g) => {
    if (g.status && groups[g.status]) {
      groups[g.status].push({
        nama: g.nama_lengkap,
        keterangan: g.keterangan || "",
      });
    }
  });

  // Header pesan
  let message = `📅 *Absensi Pengajian Generus*\n`;
  message += `*Kelompok:* ${kelompokNama.value}\n`;
  message += `*Tanggal:* ${tanggalLengkap}\n`;

  if (sesi.value) message += `*Sesi:* ${sesi.value}\n`;
  if (materi.value) message += `*Materi:* ${materi.value}\n`;

  message += `\n`;

  // Emoji per kategori
  const emojiMap = {
    Hadir: "✅",
    Terlambat: "🕐",
    Izin: "📋",
    Sakit: "🤒",
    Alpa: "❌",
  };

  let totalAbsensi = 0;
  const order = ["Hadir", "Terlambat", "Izin", "Sakit", "Alpa"];

  // Loop tiap kategori
  order.forEach((kategori) => {
    const list = groups[kategori];
    if (list.length > 0) {
      message += `${emojiMap[kategori]} *${kategori}*\n`;
      list.forEach((item) => {
        message += item.keterangan
          ? `- ${item.nama} (${item.keterangan})\n`
          : `- ${item.nama}\n`;
      });
      message += "\n";
      totalAbsensi += list.length;
    }
  });

  // Belum diabsen
  const belum = generusList.value.filter((g) => !g.status).length;
  if (belum > 0) {
    message += `📭 *Belum Diabsen:* ${belum} generus\n\n`;
  }

  // Ringkasan
  const summary = order.map((k) => `${k}: ${groups[k].length}`).join(" | ");
  message += `📊 *Ringkasan:*\n${summary}\n\n`;

  // Total absensi
  message += `Total Diabsen: ${totalAbsensi} dari ${generusList.value.length} generus\n`;

  return message;
}

async function submitAbsensi() {
  submitLoading.value = true;

  try {
    const payload = {
      generus: generusList.value,
      tanggal: tanggalDipilih.value,
      materi: materi.value,
      sesi: sesi.value,
      kelompok_id: kelompokId.value,
    };

    const res = await fetch("https://absensi.ppgtarakan.com/api/absensi.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    const data = await res.json();

    if (data.status) {
      whatsappMessage.value = generateWhatsappMessage();
    } else {
      alert(data.message);
    }
  } catch (err) {
    console.error(err);
    alert("Gagal submit absensi");
  } finally {
    submitLoading.value = false;
  }
}

function sendToWhatsapp() {
  window.open(
    `https://api.whatsapp.com/send?text=${encodeURIComponent(
      whatsappMessage.value,
    )}`,
    "_blank",
  );
}

function copyToClipboard() {
  navigator.clipboard
    .writeText(whatsappMessage.value)
    .then(() => alert("Teks disalin"));
}

// default: tanggal hari ini (Indonesia / WIB)
const tanggalDipilih = ref(getTanggalHariIni());

// Ambil tanggal hari ini format YYYY-MM-DD (untuk input type="date")
function getTanggalHariIni() {
  const sekarang = new Date();

  // paksa ke zona waktu Indonesia (WIB GMT+7)
  const formatter = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Jakarta",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });

  return formatter.format(sekarang);
}

// Format tampilan Indonesia (contoh: 15 Februari 2026)
const tanggalFormatIndonesia = computed(() => {
  const date = new Date(tanggalDipilih.value);

  return new Intl.DateTimeFormat("id-ID", {
    timeZone: "Asia/Jakarta",
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  }).format(date);
});

const materi = ref("");
const sesi = ref("subuh");
const daftarSesi = ["subuh", "pagi", "siang", "malam"];
function detectSesiOtomatis() {
  const now = new Date();

  // ambil jam WIB
  const jamWIB = new Intl.DateTimeFormat("en-US", {
    timeZone: "Asia/Jakarta",
    hour: "2-digit",
    hour12: false,
  }).format(now);

  const jam = parseInt(jamWIB);

  if (jam >= 3 && jam < 6) {
    return "subuh";
  } else if (jam >= 6 && jam < 11) {
    return "pagi";
  } else if (jam >= 11 && jam < 15) {
    return "siang";
  } else {
    return "malam";
  }
}

function cardBorder(status) {
  switch (status) {
    case "Hadir":
      return "border-emerald-500";
    case "Izin":
      return "border-amber-500";
    case "Sakit":
      return "border-red-500";
    case "Alpa":
      return "border-gray-500";
    case "Terlambat":
      return "border-orange-600";
    default:
      return "border-black";
  }
}

function cardStrip(status) {
  switch (status) {
    case "Hadir":
      return "bg-emerald-500";
    case "Izin":
      return "bg-amber-500";
    case "Sakit":
      return "bg-red-500";
    case "Alpa":
      return "bg-gray-500";
    case "Terlambat":
      return "bg-orange-600";
    default:
      return "bg-gray-200";
  }
}

function namaStyle(status) {
  switch (status) {
    case "Hadir":
      return "bg-emerald-100 text-emerald-900 border-2 border-emerald-500";
    case "Izin":
      return "bg-amber-100 text-amber-900 border-2 border-amber-500";
    case "Sakit":
      return "bg-red-100 text-red-900 border-2 border-red-500";
    case "Alpa":
      return "bg-gray-100 text-gray-700 border-2 border-gray-500";
    case "Terlambat":
      return "bg-orange-100 text-orange-800 border-2 border-orange-600";
    default:
      return "bg-transparent border-2 border-transparent";
  }
}

function badgeStyle(status) {
  switch (status) {
    case "Hadir":
      return "bg-emerald-500";
    case "Izin":
      return "bg-amber-500";
    case "Sakit":
      return "bg-red-500";
    case "Alpa":
      return "bg-gray-500";
    case "Terlambat":
      return "bg-orange-600";
    default:
      return "bg-black";
  }
}

function statusButton(selected, current) {
  const base = {
    Hadir: "text-emerald-900 border-emerald-900",
    Izin: "text-amber-900 border-amber-900",
    Sakit: "text-red-900 border-red-900",
    Alpa: "text-gray-700 border-gray-700",
    Terlambat: "text-orange-800 border-orange-800",
  };

  if (selected === current) {
    return `${base[current]} bg-${colorMap(current)} text-white scale-105 shadow-[2px_2px_0_black]`;
  }

  return `${base[current]} bg-white hover:-translate-y-0.5`;
}

function colorMap(status) {
  switch (status) {
    case "Hadir":
      return "emerald-500";
    case "Izin":
      return "amber-500";
    case "Sakit":
      return "red-500";
    case "Alpa":
      return "gray-500";
    case "Terlambat":
      return "orange-500";
    default:
      return "black";
  }
}
</script>
