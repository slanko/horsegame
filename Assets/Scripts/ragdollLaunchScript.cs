using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ragdollLaunchScript : MonoBehaviour
{
    bool launched = false;
    bool resetInvoked;
    public bool willLaunch;
    public float launchForce;
    Rigidbody rb;
    public GameObject myHips;
    characterController cC;
    // Start is called before the first frame update
    void Start()
    {
        cC = GameObject.Find("Player").GetComponent<characterController>();
        rb = myHips.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if(willLaunch == true)
        {
            if (launched == false)
            {
                rb.AddForce(Vector3.up * launchForce * 1000);
                launched = true;
            }
        }

        if(rb.velocity.y < 1)
        {
            if(resetInvoked == false)
            {
                Invoke("goToGoToGrounded", 3);
                resetInvoked = true;
            }
        }
    }

    void goToGoToGrounded()
    {
        cC.goToGrounded();
    }
}
