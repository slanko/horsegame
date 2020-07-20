using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class goToThing : MonoBehaviour
{
    public GameObject targetToFollow;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = targetToFollow.transform.position;
    }
}
