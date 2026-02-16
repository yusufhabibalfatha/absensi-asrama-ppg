<template>
  <div class="grid gap-2 my-6 grid-cols-[repeat(auto-fit,minmax(120px,1fr))]">
    <!-- Hadir -->
    <div
      class="bg-emerald-100 border-2 border-emerald-500 rounded-lg p-3 text-center"
    >
      <div class="text-2xl font-extrabold text-emerald-900">
        {{ stats.Hadir || 0 }}
      </div>
      <div class="text-xs font-semibold text-emerald-900">✅ Hadir</div>
    </div>

    <!-- Izin -->
    <div
      class="bg-amber-100 border-2 border-amber-500 rounded-lg p-3 text-center"
    >
      <div class="text-2xl font-extrabold text-amber-800">
        {{ stats.Izin || 0 }}
      </div>
      <div class="text-xs font-semibold text-amber-800">📋 Izin</div>
    </div>

    <!-- Tidak Hadir (Sakit + Alpa) -->
    <div class="bg-red-100 border-2 border-red-500 rounded-lg p-3 text-center">
      <div class="text-2xl font-extrabold text-red-900">
        {{ (stats.Sakit || 0) + (stats.Alpa || 0) }}
      </div>
      <div class="text-xs font-semibold text-red-900">❌ Tidak Hadir</div>
    </div>

    <!-- Terlambat -->
    <div
      class="bg-orange-50 border-2 border-orange-600 rounded-lg p-3 text-center"
    >
      <div class="text-2xl font-extrabold text-orange-700">
        {{ stats.Terlambat || 0 }}
      </div>
      <div class="text-xs font-semibold text-orange-700">🐢 Terlambat</div>
    </div>

    <!-- Belum -->
    <div
      class="bg-gray-100 border-2 border-gray-500 rounded-lg p-3 text-center"
    >
      <div class="text-2xl font-extrabold text-gray-700">
        {{ stats.Belum || 0 }}
      </div>
      <div class="text-xs font-semibold text-gray-700">⏳ Belum</div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  stats: {
    type: Object,
    required: true,
  },
});
</script>
