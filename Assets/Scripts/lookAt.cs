using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class lookAt : MonoBehaviour
{
    public GameObject lookTarget;
    void Update()
    {
        transform.LookAt(lookTarget.transform.position);
    }
}
