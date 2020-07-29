using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class ragdollResetScript : MonoBehaviour
{
    void Update()
    {
        if(transform.position.y < -100)
        {
            transform.position = new Vector3(0, 200, 0);
        }
    }
}