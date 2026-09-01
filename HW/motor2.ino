#include <WiFi.h>
#include "esp_wifi.h"
#include "esp_event.h"
#include "LittleFS.h"
#include <WebServer.h>

// ==========================================
// ZZIP - ESP32 CSI DATA COLLECTION
// + LittleFS CSV AUTO SAVING
// + WEB CSV DOWNLOAD
//
// Board : ESP32-WROOM-32
// Arduino ESP32 Core : 3.3.11
//
// 기능
// 1. CSI 수집
// 2. /csi_data.csv 저장
// 3. 웹브라우저에서 CSV 다운로드
// 4. 기존 CSV 자동 삭제 안 함
// ==========================================


// ==========================================
// Wi-Fi
// ==========================================

const char* WIFI_SSID = "KT_GiGA_5A1E";
const char* WIFI_PASSWORD = "de07ff3197";


// ==========================================
// CSV
// ==========================================

const char* CSV_FILE = "/csi_data.csv";

File csvFile;


// ==========================================
// Web Server
// ==========================================

WebServer server(80);


// ==========================================
// CSI COUNT
// ==========================================

volatile unsigned long csiCount = 0;
volatile unsigned long savedCount = 0;


// ==========================================
// COLLECTION STATE
// ==========================================

bool collecting = true;


// ==========================================
// CSI CALLBACK
// ==========================================

void wifi_csi_rx_cb(void* ctx, wifi_csi_info_t* data) {

  if (!collecting) {
    return;
  }

  if (data == nullptr || data->buf == nullptr) {
    return;
  }

  csiCount++;


  // ----------------------------------------
  // CSV 저장
  // ----------------------------------------

  if (csvFile) {

    csvFile.print(millis());
    csvFile.print(",");

    csvFile.print(data->rx_ctrl.rssi);
    csvFile.print(",");

    csvFile.print(data->len);
    csvFile.print(",");

    csvFile.print("\"[");

    for (int i = 0; i < data->len; i++) {

      csvFile.print((int)data->buf[i]);

      if (i < data->len - 1) {
        csvFile.print(",");
      }
    }

    csvFile.println("]\"");

    savedCount++;
  }
}


// ==========================================
// CSI INITIALIZATION
// ==========================================

void initCSI() {

  esp_wifi_set_promiscuous(true);


  wifi_csi_config_t csi_config = {
    .lltf_en = true,
    .htltf_en = true,
    .stbc_htltf2_en = true,
    .ltf_merge_en = true,
    .channel_filter_en = true,
    .manu_scale = false,
    .shift = 0,
    .dump_ack_en = false
  };


  esp_err_t err;


  // CSI config
  err = esp_wifi_set_csi_config(&csi_config);

  Serial.print("CSI CONFIG: ");

  if (err == ESP_OK) {
    Serial.println("OK");
  }
  else {
    Serial.print("ERROR = ");
    Serial.println((int)err);
  }


  // CSI callback
  err = esp_wifi_set_csi_rx_cb(
    wifi_csi_rx_cb,
    nullptr
  );

  Serial.print("CSI CALLBACK: ");

  if (err == ESP_OK) {
    Serial.println("OK");
  }
  else {
    Serial.print("ERROR = ");
    Serial.println((int)err);
  }


  // CSI enable
  err = esp_wifi_set_csi(true);

  Serial.print("CSI ENABLE: ");

  if (err == ESP_OK) {
    Serial.println("OK");
  }
  else {
    Serial.print("ERROR = ");
    Serial.println((int)err);
  }
}


// ==========================================
// LITTLEFS INITIALIZATION
// ==========================================

bool initLittleFS() {

  Serial.println();
  Serial.println("Starting LittleFS...");


  if (!LittleFS.begin(true)) {

    Serial.println("LITTLEFS: ERROR");

    return false;
  }


  Serial.println("LITTLEFS: OK");


  // ========================================
  // 기존 CSV가 있으면 삭제하지 않음
  // ========================================

  if (LittleFS.exists(CSV_FILE)) {

    Serial.println("Existing CSV found.");
    Serial.println("Existing CSV will NOT be deleted.");

    csvFile = LittleFS.open(
      CSV_FILE,
      FILE_APPEND
    );

  }
  else {

    Serial.println("Creating new CSV...");

    csvFile = LittleFS.open(
      CSV_FILE,
      FILE_WRITE
    );

    if (csvFile) {

      csvFile.println(
        "timestamp_ms,rssi,csi_len,csi_data"
      );

      csvFile.flush();
    }
  }


  if (!csvFile) {

    Serial.println("CSV FILE: ERROR");

    return false;
  }


  Serial.println("CSV FILE: OK");

  Serial.print("FILE: ");
  Serial.println(CSV_FILE);


  return true;
}


// ==========================================
// WEB PAGE
// ==========================================

void handleRoot() {

  String html = "";

  html += "<!DOCTYPE html>";
  html += "<html>";
  html += "<head>";
  html += "<meta charset='UTF-8'>";
  html += "<meta name='viewport' content='width=device-width, initial-scale=1'>";
  html += "<title>ZZIP CSI</title>";
  html += "</head>";

  html += "<body>";

  html += "<h1>ZZIP CSI Data</h1>";

  html += "<p>ESP32 IP: ";
  html += WiFi.localIP().toString();
  html += "</p>";

  html += "<p>CSI COUNT: ";
  html += String(csiCount);
  html += "</p>";

  html += "<p>SAVED: ";
  html += String(savedCount);
  html += "</p>";

  html += "<p>COLLECTION: ";

  if (collecting) {
    html += "RUNNING";
  }
  else {
    html += "STOPPED";
  }

  html += "</p>";


  // ----------------------------------------
  // Stop button
  // ----------------------------------------

  html += "<p>";
  html += "<a href='/stop'>";
  html += "<button style='font-size:20px;padding:15px;'>STOP COLLECTION</button>";
  html += "</a>";
  html += "</p>";


  // ----------------------------------------
  // Download button
  // ----------------------------------------

  html += "<p>";
  html += "<a href='/download'>";
  html += "<button style='font-size:20px;padding:15px;'>DOWNLOAD CSV</button>";
  html += "</a>";
  html += "</p>";


  html += "</body>";
  html += "</html>";


  server.send(
    200,
    "text/html",
    html
  );
}


// ==========================================
// STOP COLLECTION
// ==========================================

void handleStop() {

  collecting = false;


  // CSI 중지
  esp_wifi_set_csi(false);


  // CSV 파일 닫기
  if (csvFile) {

    csvFile.flush();
    csvFile.close();
  }


  Serial.println();
  Serial.println("========================================");
  Serial.println("CSI COLLECTION STOPPED");
  Serial.println("CSV FILE CLOSED");
  Serial.println("========================================");


  server.send(
    200,
    "text/html",
    "<h1>CSI COLLECTION STOPPED</h1>"
    "<p>CSV file is safely closed.</p>"
    "<p><a href='/download'>DOWNLOAD CSV</a></p>"
  );
}


// ==========================================
// CSV DOWNLOAD
// ==========================================

void handleDownload() {

  // 안전을 위해 수집 중이면 먼저 중지
  if (collecting) {

    collecting = false;

    esp_wifi_set_csi(false);

    if (csvFile) {

      csvFile.flush();
      csvFile.close();
    }
  }


  if (!LittleFS.exists(CSV_FILE)) {

    server.send(
      404,
      "text/plain",
      "CSV file not found."
    );

    return;
  }


  File downloadFile = LittleFS.open(
    CSV_FILE,
    FILE_READ
  );


  if (!downloadFile) {

    server.send(
      500,
      "text/plain",
      "Could not open CSV file."
    );

    return;
  }


  server.sendHeader(
    "Content-Disposition",
    "attachment; filename=csi_data.csv"
  );

  server.streamFile(
    downloadFile,
    "text/csv"
  );


  downloadFile.close();


  Serial.println();
  Serial.println("CSV DOWNLOAD REQUESTED");
}


// ==========================================
// SETUP
// ==========================================

void setup() {

  Serial.begin(115200);

  delay(1000);


  Serial.println();
  Serial.println("========================================");
  Serial.println("ZZIP ESP32 CSI COLLECTION");
  Serial.println("LittleFS CSV + WEB DOWNLOAD");
  Serial.println("========================================");


  // ========================================
  // LittleFS
  // ========================================

  bool fsOK = initLittleFS();


  if (!fsOK) {

    Serial.println("WARNING: CSV saving unavailable.");
  }


  // ========================================
  // Wi-Fi
  // ========================================

  WiFi.mode(WIFI_STA);

  WiFi.begin(
    WIFI_SSID,
    WIFI_PASSWORD
  );


  Serial.print("WiFi connecting");


  while (WiFi.status() != WL_CONNECTED) {

    delay(500);

    Serial.print(".");
  }


  Serial.println();

  Serial.println("WiFi connected!");

  Serial.print("SSID: ");
  Serial.println(WIFI_SSID);

  Serial.print("ESP32 IP: ");
  Serial.println(WiFi.localIP());

  Serial.print("WiFi RSSI: ");
  Serial.println(WiFi.RSSI());


  // ========================================
  // WEB SERVER
  // ========================================

  server.on(
    "/",
    handleRoot
  );


  server.on(
    "/stop",
    handleStop
  );


  server.on(
    "/download",
    handleDownload
  );


  server.begin();


  Serial.println();
  Serial.println("WEB SERVER STARTED");

  Serial.print("Open in browser: http://");
  Serial.println(WiFi.localIP());


  // ========================================
  // CSI START
  // ========================================

  Serial.println();
  Serial.println("Starting CSI...");

  initCSI();


  Serial.println();
  Serial.println("========================================");
  Serial.println("CSI COLLECTION START");
  Serial.println("CSV SAVING START");
  Serial.println("========================================");
}


// ==========================================
// LOOP
// ==========================================

void loop() {

  // ----------------------------------------
  // Web server
  // ----------------------------------------

  server.handleClient();


  // ----------------------------------------
  // 1초마다 상태 출력
  // ----------------------------------------

  static unsigned long lastPrint = 0;

  if (millis() - lastPrint >= 1000) {

    lastPrint = millis();


    Serial.print("CSI_COUNT=");
    Serial.print(csiCount);

    Serial.print(" | SAVED=");
    Serial.println(savedCount);
  }


  // ----------------------------------------
  // Flash에 주기적으로 저장
  // ----------------------------------------

  static unsigned long lastFlush = 0;

  if (millis() - lastFlush >= 1000) {

    lastFlush = millis();


    if (csvFile) {
      csvFile.flush();
    }
  }


  delay(10);
}