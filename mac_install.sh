brew install python
major=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:1])))')
echo " your python version is:"

python --version

if [ $major -lt  3 ]
then
	echo "Intall python version greater than 3.5"
else
	minor=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
	if [ $minor -lt 5 ]
	then
		echo "Install python version greater than 3."
	fi
fi

brew install swi-prolog

pip install -r requirements.txt
