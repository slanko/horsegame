using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class goToThing : MonoBehaviour
{
    public GameObject targetToFollow;
    public bool alsoRotation;

    // Update is called once per frame
    void Update()
    {
        transform.position = targetToFollow.transform.position;
        if(alsoRotation == true)
        {
            transform.rotation = targetToFollow.transform.rotation;
        }
    }
}
