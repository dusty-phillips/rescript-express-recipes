import requests
import json

for i in range(8):
    print(
        requests.post(
            "http://localhost:3000/addRecipe",
            data=json.dumps(
                {"title": f"{i}", "instructions": "blah", "ingredients": "blat"}
            ),
            headers={"content-type": "application/json"},
        ).json()
    )
