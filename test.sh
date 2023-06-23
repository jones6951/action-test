#! /bin/bash
        url=https://testing.blackduck.synopsys.com
        token=ZWI3ZGZlZmItMTlkMS00ODk0LWI1ZTYtY2EwMWNmZjFiMmNmOjM0YWM0N2NhLWI3ZWEtNGE5My05Yjg5LWZlZDdiYTQ2MTE4Zg==
        projectName=MJ-jhipster
        projectVersion=1.0.0
        reportFormat=JSON
        reportType=SBOM
        locale=en_US
        sbomType=SPDX_22

        bearerToken=$(curl -k -s -X POST "$url/api/tokens/authenticate" -H 'Accept: application/vnd.blackducksoftware.user-4+json' -H "Authorization: token $token" | cut -d '"' -f 4)
        if [ -z "$bearerToken" ]; then
                echo "Error getting bearerToken"
                return 1
        fi
        projectID=$(curl -k -s -X GET "$url/api/projects?q=name:$projectName" -H "Authorization: bearer $bearerToken" -H "Accept: application/vnd.blackducksoftware.project-detail-6+json" | cut -d '"' -f 80)
projectID=$(echo $projectID | cut -d '/' -f 6)
        if [ -z "$projectID" ]; then
                echo "Error getting Project ID"
                return 1
        fi
        versionID=$(curl -k -s -X GET "$url/api/projects/$projectID/versions?q=versionName=$projectVersion" -H "Authorization: bearer $bearerToken" -H "Accept: application/vnd.blackducksoftware.project-detail-5+json" | cut -d '"' -f 98)
versionID=$(echo $versionID | cut -d '/' -f 8)
        if [ -z "$versionID" ]; then
                echo "Error getting Project Version ID"
                return 1
        fi
        reportDetails=$(curl -k -i -s -X POST "$url/api/projects/$projectID/versions/$versionID/sbom-reports" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: bearer $bearerToken" -d "{\"locale\": \"$locale\",\"reportFormat\": \"$reportFormat\",\"reportType\": \"$reportType\",\"sbomType\": \"$sbomType\"}")
echo $reportDetails


