#!/bin/bash
# 30_update_docs.sh
# Kiro Hook: on-save
# الوظيفة: تحديث التوثيق تلقائيًا عند حفظ ملفات معينة.

FILE_PATH="$1"

echo "Running Kiro on-save hook: 30_update_docs.sh for file: $FILE_PATH"

# إذا تم حفظ ملف في مجلد specs/ أو steering/، قم بتحديث README.md
if [[ "$FILE_PATH" == *".kiro/specs/"* ]] || [[ "$FILE_PATH" == *".kiro/steering/"* ]]; then
    echo "Detected change in Kiro configuration. Triggering README update..."
    # في بيئة Kiro IDE الفعلية، سيتم هنا استدعاء وكيل Kiro لتوليد محتوى جديد لـ README.md
    # محاكاة عملية التحديث
    echo "README.md update simulated. Kiro Agent would now regenerate documentation based on new specs/steering."
fi

exit 0
