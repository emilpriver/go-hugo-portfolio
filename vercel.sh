#!/bin/bash

if [[ $VERCEL_GIT_COMMIT_REF == "main" ]]; then
	echo "This is our main branch"
	hugo
else
	echo "This is not our main branch, building drafts"
	hugo -D
fi
