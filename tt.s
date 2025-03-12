const CLASS_SUFFIX = "Model"; // Suffix to add to all class names

function generateDartClass(json: any, className: string = "Root"): string {
    const classWithSuffix = capitalizeFirstLetter(className) + CLASS_SUFFIX;
    let result = `class ${classWithSuffix} {\n`;
    let nestedClasses = "";

    // Generate class fields
    for (const key in json) {
        if (json.hasOwnProperty(key)) {
            const value = json[key];
            const dartType = getDartType(key, value);

            if (typeof value === "object" && !Array.isArray(value)) {
                const nestedClassName = capitalizeFirstLetter(key) + CLASS_SUFFIX;
                nestedClasses += generateDartClass(value, key) + "\n";
                result += `  final ${nestedClassName} ${key};\n`;
            } else if (Array.isArray(value) && value.length > 0 && typeof value[0] === "object") {
                const nestedClassName = capitalizeFirstLetter(key) + "Item" + CLASS_SUFFIX;
                nestedClasses += generateDartClass(value[0], key + "Item") + "\n";
                result += `  final List<${nestedClassName}> ${key};\n`;
            } else {
                result += `  final ${dartType} ${key};\n`;
            }
        }
    }

    // Constructor
    result += `\n  ${classWithSuffix}({\n`;
    for (const key in json) {
        if (json.hasOwnProperty(key)) {
            result += `    required this.${key},\n`;
        }
    }
    result += "  });\n\n";

    // fromJson method
    result += `  factory ${classWithSuffix}.fromJson(Map<String, dynamic> json) {\n`;
    result += `    return ${classWithSuffix}(\n`;
    for (const key in json) {
        if (json.hasOwnProperty(key)) {
            const value = json[key];

            if (typeof value === "object" && !Array.isArray(value)) {
                const nestedClassName = capitalizeFirstLetter(key) + CLASS_SUFFIX;
                result += `      ${key}: ${nestedClassName}.fromJson(json['${key}']),\n`;
            } else if (Array.isArray(value) && value.length > 0 && typeof value[0] === "object") {
                const nestedClassName = capitalizeFirstLetter(key) + "Item" + CLASS_SUFFIX;
                result += `      ${key}: (json['${key}'] as List).map((item) => ${nestedClassName}.fromJson(item)).toList(),\n`;
            } else {
                result += `      ${key}: json['${key}'],\n`;
            }
        }
    }
    result += `    );\n  }\n\n`;

    // toJson method
    result += `  Map<String, dynamic> toJson() {\n`;
    result += `    return {\n`;
    for (const key in json) {
        if (json.hasOwnProperty(key)) {
            const value = json[key];

            if (typeof value === "object" && !Array.isArray(value)) {
                result += `      '${key}': ${key}.toJson(),\n`;
            } else if (Array.isArray(value) && value.length > 0 && typeof value[0] === "object") {
                result += `      '${key}': ${key}.map((item) => item.toJson()).toList(),\n`;
            } else {
                result += `      '${key}': ${key},\n`;
            }
        }
    }
    result += `    };\n  }\n}\n\n`;

    return result + nestedClasses;
}

function getDartType(key: string, value: any): string {
    if (typeof value === "number") return value % 1 === 0 ? "int" : "double";
    if (typeof value === "boolean") return "bool";
    if (typeof value === "string") return "String";
    if (Array.isArray(value)) return value.length > 0 ? `List<${getDartType(key, value[0])}>` : "List<dynamic>";
    if (typeof value === "object") return capitalizeFirstLetter(key) + CLASS_SUFFIX;
    return "dynamic";
}

function capitalizeFirstLetter(text: string): string {
    return text.charAt(0).toUpperCase() + text.slice(1);
}

// Example usage
const jsonExample = {
    "medications":[{
            "aceInhibitors":[{
                "name":"lisinopril",
                "strength":"10 mg Tab",
                "dose":"1 tab",
                "route":"PO",
                "sig":"daily",
                "pillCount":"#90",
                "refills":"Refill 3"
            }],
            "antianginal":[{
                "name":"nitroglycerin",
                "strength":"0.4 mg Sublingual Tab",
                "dose":"1 tab",
                "route":"SL",
                "sig":"q15min PRN",
                "pillCount":"#30",
                "refills":"Refill 1"
            }],
            "anticoagulants":[{
                "name":"warfarin sodium",
                "strength":"3 mg Tab",
                "dose":"1 tab",
                "route":"PO",
                "sig":"daily",
                "pillCount":"#90",
                "refills":"Refill 3"
            }],
            "betaBlocker":[{
                "name":"metoprolol tartrate",
                "strength":"25 mg Tab",
                "dose":"1 tab",
                "route":"PO",
                "sig":"daily",
                "pillCount":"#90",
                "refills":"Refill 3"
            }],
            "diuretic":[{
                "name":"furosemide",
                "strength":"40 mg Tab",
                "dose":"1 tab",
                "route":"PO",
                "sig":"daily",
                "pillCount":"#90",
                "refills":"Refill 3"
            }],
            "mineral":[{
                "name":"potassium chloride ER",
                "strength":"10 mEq Tab",
                "dose":"1 tab",
                "route":"PO",
                "sig":"daily",
                "pillCount":"#90",
                "refills":"Refill 3"
            }]
        }
    ],
    "labs":[{
        "name":"Arterial Blood Gas",
        "time":"Today",
        "location":"Main Hospital Lab"      
        },
        {
        "name":"BMP",
        "time":"Today",
        "location":"Primary Care Clinic"    
        },
        {
        "name":"BNP",
        "time":"3 Weeks",
        "location":"Primary Care Clinic"    
        },
        {
        "name":"BUN",
        "time":"1 Year",
        "location":"Primary Care Clinic"    
        },
        {
        "name":"Cardiac Enzymes",
        "time":"Today",
        "location":"Primary Care Clinic"    
        },
        {
        "name":"CBC",
        "time":"1 Year",
        "location":"Primary Care Clinic"    
        },
        {
        "name":"Creatinine",
        "time":"1 Year",
        "location":"Main Hospital Lab"  
        },
        {
        "name":"Electrolyte Panel",
        "time":"1 Year",
        "location":"Primary Care Clinic"    
        },
        {
        "name":"Glucose",
        "time":"1 Year",
        "location":"Main Hospital Lab"  
        },
        {
        "name":"PT/INR",
        "time":"3 Weeks",
        "location":"Primary Care Clinic"    
        },
        {
        "name":"PTT",
        "time":"3 Weeks",
        "location":"Coumadin Clinic"    
        },
        {
        "name":"TSH",
        "time":"1 Year",
        "location":"Primary Care Clinic"    
        }
    ],
    "imaging":[{
        "name":"Chest X-Ray",
        "time":"Today",
        "location":"Main Hospital Radiology"    
        },
        {
        "name":"Chest X-Ray",
        "time":"Today",
        "location":"Main Hospital Radiology"    
        },
        {
        "name":"Chest X-Ray",
        "time":"Today",
        "location":"Main Hospital Radiology"    
        }
    ]
};

console.log(generateDartClass(jsonExample));
