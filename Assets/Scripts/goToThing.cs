using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class goToThing : MonoBehaviour
{
    public GameObject targetToFollow;

    // Update is called once per frame
    void Update()
    {
        transform.position = targetToFollow.transform.position;
    }
}
