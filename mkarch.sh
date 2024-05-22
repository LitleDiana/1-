#!/bin/bash

while getopts "d:n:" option; do
	case "${option}" in
    		d)
			dir_path=${OPTARG}
      			;;
    		n)
      			name=${OPTARG}
      			;;
                \?)
                        exit 1
                        ;;
                :)
                        exit 1
                        ;;
  	esac
done

if [ -z "${dir_path}" ] || [ -z "${name}" ]; then
  echo "Необходисый формат: $0 -d dir_path -n name"
  exit 1
fi

cat << EOF > "${name}"
#!/bin/bash
while getopts "o:" option; do
        case "\${option}" in
                o)
                        unpack_dir=\$OPTARG
                        ;;
                \?)
                        exit 1
                        ;;
                :)
                        exit 1
                        ;;
        esac
done
if [ -z "\${unpack_dir}" ]; then
	unpack_dir="."
fi
#line_eof=\$(grep -an '^EOF\$' "\$0" | cut -d: -f1)
line_eof=\$(awk '/^__ARCHIVE_BELOW__$/ {print NR + 1; exit 0; }' "\$0")
tail -n +\${line_eof} "\$0" | base64 -d | (cd "\$unpack_dir" && tar xzf -)
rm "\$0"
exit 0
__ARCHIVE_BELOW__
EOF

(cd "${dir_path}" && tar czf - .) | base64 >> "$name"
chmod +x "$name"
