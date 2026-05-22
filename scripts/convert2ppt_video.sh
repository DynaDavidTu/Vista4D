#!/bin/bash

# 初始化變數
INPUT_FILE=""

# 使用 getopts 解析 -i 參數
while getopts "i:" opt; do
  case ${opt} in
    i )
      INPUT_FILE=$OPTARG
      ;;
    \? )
      echo "錯誤：不支援的參數"
      echo "用法：$0 -i <輸入影片路徑>"
      exit 1
      ;;
  esac
done

# 檢查是否有提供輸入檔案
if [ -z "$INPUT_FILE" ]; then
    echo "錯誤：請使用 -i 指定輸入影片檔案。"
    echo "用法：$0 -i <輸入影片路徑>"
    exit 1
fi

# 檢查檔案是否存在
if [ ! -f "$INPUT_FILE" ]; then
    echo "錯誤：找不到檔案 '$INPUT_FILE'"
    exit 1
fi

# --- 自動解析路徑與命名 ---

# 1. 取得檔案所在的資料夾路徑 (例如: results/single/room/vista4d_384p)
DIR_PATH=$(dirname "$INPUT_FILE")

# 2. 取得最後一層資料夾的名稱 (例如: vista4d_384p)
PARENT_DIR=$(basename "$DIR_PATH")

# 3. 從資料夾名稱中萃取出關鍵字（依據你的範例，將 vista4d_384p 轉為 room_384p）
# 這裡的邏輯是：如果上一層資料夾是 room，就結合後面的解析度
# 如果你的路徑結構固定，以下法最精準：
GRANDPARENT_DIR=$(basename "$(dirname "$DIR_PATH")") # 取得 "room"
RESOLUTION=$(echo "$PARENT_DIR" | grep -oE '[0-9]+p') # 萃取 "384p"

# 組合出輸出檔名 (例如: room_384p.mp4)
OUTPUT_NAME="${GRANDPARENT_DIR}_${RESOLUTION}.mp4"

# 組合出完整輸出路徑
OUTPUT_FILE="${DIR_PATH}/${OUTPUT_NAME}"

# --- 執行 FFmpeg 指令 ---

echo "========================================"
echo "輸入檔案：$INPUT_FILE"
echo "自動輸出：$OUTPUT_FILE"
echo "========================================"
echo "正在處理中，請稍候..."

ffmpeg -i "$INPUT_FILE" -vf "settb=expr=1/30,setpts=expr=N*30,fps=30" "$OUTPUT_FILE" -y

if [ $? -eq 0 ]; then
    echo "🎉 處理完成！輸出檔案位於：$OUTPUT_FILE"
else
    echo "❌ FFmpeg 執行失敗，請檢查錯誤訊息。"
fi